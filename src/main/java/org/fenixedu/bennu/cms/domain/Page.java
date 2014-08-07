package org.fenixedu.bennu.cms.domain;

import java.util.UUID;

import org.fenixedu.bennu.core.domain.User;
import org.fenixedu.bennu.core.security.Authenticate;
import org.fenixedu.bennu.core.util.CoreConfiguration;
import org.fenixedu.commons.i18n.LocalizedString;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import pt.ist.fenixframework.Atomic;

import com.google.common.base.Joiner;
import com.google.common.base.Strings;

/**
 * Model for a page on a given Site.
 */
public class Page extends Page_Base {
    private static final Logger log = LoggerFactory.getLogger(Page.class);

    /**
     * the logged {@link User} creates a new Page.
     */
    public Page() {
        super();
        this.setCreationDate(new DateTime());
        if (Authenticate.getUser() == null) {
            throw new RuntimeException("Needs Login");
        }
        this.setCreatedBy(Authenticate.getUser());
    }

    @Override
    public void setName(LocalizedString name) {
        LocalizedString prevName = getName();
        super.setName(name);

        if (prevName == null) {
            setSlug(Site.slugify(name.getContent()));
        }
    }

    @Override
    public void setSlug(String slug) {
        while (!isValidSlug(slug)) {
            String randomSlug = UUID.randomUUID().toString().substring(0, 3);
            slug = Joiner.on("-").join(slug, randomSlug);
        }
        super.setSlug(slug);
    }

    /**
     * A slug is valid if there are no other page on that site that have the same slug.
     * 
     * @param slug
     * @return true if it is a valid slug.
     */
    private boolean isValidSlug(String slug) {
        return !Strings.isNullOrEmpty(slug) && getSite().pageForSlug(slug) == null;
    }

    /**
     * Searches a {@link Component} of this page by oid.
     * 
     * @param oid
     *            the oid of the {@link Component} to be searched.
     * @return
     *         the {@link Component} with the given oid if it is a component of this page and null otherwise.
     */
    public Component componentForOid(String oid) {
        for (Component c : getComponentsSet()) {
            if (c.getExternalId().equals(oid)) {
                return c;
            }
        }
        return null;
    }

    @Atomic
    public void delete() {
        for (Component component : getComponentsSet()) {
            component.delete();
        }
        this.setTemplate(null);
        this.setSite(null);
        this.setCreatedBy(null);
        this.deleteDomainObject();
    }

    /**
     * @return the URL link for this page.
     */
    public String getAddress() {
        String path = CoreConfiguration.getConfiguration().applicationUrl();
        if (path.charAt(path.length() - 1) != '/') {
            path += "/";
        }
        path += getSite().getSlug() + "/" + getSlug();
        return path;
    }

    public static Page create(Site site, Menu menu, MenuItem parent, LocalizedString name, boolean published, String template,
            Component... components) {
        Page page = new Page();
        page.setSite(site);
        page.setName(name);
        if (components != null && components.length > 0) {
            for (Component component : components) {
                page.addComponents(component);
            }
        }
        page.setTemplate(site.getTheme().templateForType(template));
        page.setPublished(published);
        if (menu != null) {
            MenuItem.create(site, menu, page, name, parent);
        }
        log.info("[ Page created { name: " + page.getName().getContent() + ", address: " + page.getAddress() + " }");
        return page;
    }
}
