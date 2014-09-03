package org.fenixedu.bennu.cms.portal;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import org.fenixedu.bennu.cms.domain.CMSTheme;
import org.fenixedu.bennu.cms.domain.Site;
import org.fenixedu.bennu.cms.exceptions.CmsDomainException;
import org.fenixedu.bennu.core.domain.Bennu;
import org.fenixedu.bennu.core.domain.User;
import org.fenixedu.bennu.core.groups.DynamicGroup;
import org.fenixedu.bennu.core.groups.Group;
import org.fenixedu.bennu.core.security.Authenticate;
import org.fenixedu.bennu.spring.portal.SpringApplication;
import org.fenixedu.bennu.spring.portal.SpringFunctionality;
import org.fenixedu.commons.i18n.LocalizedString;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;
import pt.ist.fenixframework.Atomic;
import pt.ist.fenixframework.Atomic.TxMode;
import pt.ist.fenixframework.FenixFramework;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@SpringApplication(group = "anyone", path = "cms", title = "application.title")
@SpringFunctionality(app = AdminSites.class, title = "application.admin-portal.title")
@RequestMapping("/cms/sites")
public class AdminSites {

    private static final int ITEMS_PER_PAGE = 30;

    @RequestMapping
    public String list(Model model) {
        return list(0, model);
    }

    @RequestMapping(value = "manage/{page}", method = RequestMethod.GET)
    public String list(@PathVariable("page") Integer page, Model model) {
        List<List<Site>> pages = Lists.partition(getSites(), ITEMS_PER_PAGE);
        if(!pages.isEmpty()) {
            int currentPage = Optional.of(page).orElse(0);
            model.addAttribute("numberOfPages", pages.size());
            model.addAttribute("currentPage", currentPage);
            model.addAttribute("sites", pages.get(currentPage));
        }
        return "manage";
    }

    private List<Site> getSites() {
        User user = Authenticate.getUser();
        Set<Site> allSites = Bennu.getInstance().getSitesSet();
        Predicate<Site> isAdminMember = site -> site.getCanAdminGroup().isMember(user);
        Predicate<Site> isPostsMember = site -> site.getCanPostGroup().isMember(user);
        return allSites.stream().filter(isAdminMember.or(isPostsMember)).collect(Collectors.toList());
    }

    public static void canEdit(Site site) {
        if (!(site.getCanAdminGroup().isMember(Authenticate.getUser()))) {
            throw CmsDomainException.forbiden();
        }
    }


    @RequestMapping(value = "{slug}/edit", method = RequestMethod.GET)
    public String edit(Model model, @PathVariable(value = "slug") String slug) {
        Site site = Site.fromSlug(slug);

        AdminSites.canEdit(site);

        model.addAttribute("site", site);
        model.addAttribute("themes", Bennu.getInstance().getCMSThemesSet());
        model.addAttribute("folders", Bennu.getInstance().getCmsFolderSet());
        return "editSite";
    }

    @RequestMapping(value = "{slug}/edit", method = RequestMethod.POST)
    public RedirectView edit(Model model, @PathVariable(value = "slug") String slug, @RequestParam LocalizedString name,
            @RequestParam LocalizedString description, @RequestParam String theme, @RequestParam String newSlug, @RequestParam(
                    required = false) Boolean published, RedirectAttributes redirectAttributes, @RequestParam String viewGroup,
            @RequestParam String postGroup, @RequestParam String adminGroup, @RequestParam String folder) {

        if (name.isEmpty()) {
            redirectAttributes.addFlashAttribute("emptyName", true);
            return new RedirectView("/sites/" + slug + "/edit", true);
        } else {
            if (published == null) {
                published = false;
            }
            Site s = Site.fromSlug(slug);

            AdminSites.canEdit(s);

            editSite(name, description, theme, newSlug, published, s, viewGroup, postGroup, adminGroup, folder);
            return new RedirectView("/cms/sites", true);
        }
    }

    @Atomic(mode = TxMode.WRITE)
    private void editSite(LocalizedString name, LocalizedString description, String theme, String slug, Boolean published,
            Site s, String viewGroup, String postGroup, String adminGroup, String folder) {
        s.setName(name);
        s.setDescription(description);
        s.setTheme(CMSTheme.forType(theme));
        if (!Strings.isNullOrEmpty(folder)) {
            s.setFolder(FenixFramework.getDomainObject(folder));
        } else {
            // Remove the folder and set the new slug, so the MenuFunctionality will be created
            s.setFolder(null);
            s.setSlug(slug);
            s.updateMenuFunctionality();
        }

        if (!s.getSlug().equals(slug)) {
            s.setSlug(slug);
            s.updateMenuFunctionality();
        }

        s.setPublished(published);
        s.setCanViewGroup(Group.parse(viewGroup));
        s.setCanPostGroup(Group.parse(postGroup));
        s.setCanAdminGroup(Group.parse(adminGroup));
    }

    @RequestMapping(value = "{slug}/delete", method = RequestMethod.POST)
    public RedirectView delete(@PathVariable(value = "slug") String slug) {
        Site s = Site.fromSlug(slug);

        AdminSites.canEdit(s);

        s.delete();
        return new RedirectView("/cms/sites", true);
    }

    @RequestMapping(value = "default", method = RequestMethod.POST)
    public RedirectView setAsDefault(@RequestParam String slug) {
        Site s = Site.fromSlug(slug);

        if (!DynamicGroup.get("managers").isMember(Authenticate.getUser())) {
            throw CmsDomainException.forbiden();
        }

        makeDefaultSite(s);

        return new RedirectView("/cms/sites", true);
    }

    @Atomic
    private void makeDefaultSite(Site s) {
        Bennu.getInstance().setDefaultSite(s);
    }

}