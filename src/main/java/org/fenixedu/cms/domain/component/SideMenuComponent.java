package org.fenixedu.cms.domain.component;

import org.fenixedu.cms.domain.Menu;
import org.fenixedu.cms.domain.Page;
import org.fenixedu.cms.domain.wraps.Wrap;
import org.fenixedu.cms.rendering.TemplateContext;

@ComponentType(name = "Side Menu", description = "Attaches a Side Menu to a Page")
public class SideMenuComponent extends SideMenuComponent_Base {

    @DynamicComponent
    public SideMenuComponent(@ComponentParameter(value = "Menu", provider = MenusForSite.class) Menu menu) {
        super();
        setMenu(menu);
    }

    @Override
    public void handle(Page currentPage, TemplateContext local, TemplateContext global) {
        if (!getMenu().getToplevelItemsSet().isEmpty()) {
            Wrap wrap = getMenu().makeWrap(currentPage);
            local.put("sideMenu", wrap);
            handleMenu(wrap, "sideMenus", global);
        }
    }

}
