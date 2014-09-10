package org.fenixedu.bennu.cms.domain.component;

import org.fenixedu.bennu.cms.domain.Menu;
import org.fenixedu.bennu.cms.domain.Page;
import org.fenixedu.bennu.cms.rendering.TemplateContext;

@ComponentType(name = "Side Menu", description = "Attaches a Side Menu to a Page")
public class SideMenuComponent extends SideMenuComponent_Base {

    @DynamicComponent
    public SideMenuComponent(@ComponentParameter(value = "Menu", provider = MenusForSite.class) Menu menu) {
        super();
        setMenu(menu);
    }

    @Override
    public void handle(Page currentPage, TemplateContext local, TemplateContext global) {
        if (!getMenu().getChildrenSorted().isEmpty()) {
            local.put("sideMenu", getMenu().makeWrap(currentPage));
            handleMenu(getMenu(), "sideMenus", currentPage, global);
        }
    }

}
