package org.fenixedu.bennu.cms.domain.component;

import java.util.HashMap;

import org.fenixedu.bennu.cms.domain.Page;
import org.fenixedu.bennu.cms.exceptions.CmsDomainException;
import org.fenixedu.bennu.cms.rendering.TemplateContext;
import org.fenixedu.bennu.core.domain.User;
import org.fenixedu.bennu.core.security.Authenticate;
import org.joda.time.DateTime;

import pt.ist.fenixframework.Atomic;
import pt.ist.fenixframework.Atomic.TxMode;

import com.google.gson.JsonArray;

public abstract class Component extends Component_Base {

    protected static final HashMap<String, ComponentDescriptor> COMPONENTS = new HashMap<>();

    /**
     * Registers a new class has a component.
     * 
     * @param type
     *            the type of the component. It must be unique for the application.
     * @param c
     *            the class being registered as a component.
     */
    public static void register(Class<?> c) {
        COMPONENTS.put(c.getName(), new ComponentDescriptor(c));
    }

    /**
     * Searches for the class of a component with a given type.
     * 
     * @param type
     *            the type of the component.
     * @return
     *         the class of the component with the given type.
     */
    public static ComponentDescriptor forType(String type) {
        return COMPONENTS.get(type);
    }

    public static JsonArray availableComponents() {
        JsonArray array = new JsonArray();
        COMPONENTS.values().stream().map(ComponentDescriptor::toJson).forEach(obj -> array.add(obj));
        return array;
    }

    /**
     * The logged {@link User} creates a new component.
     */
    public Component() {
        super();
        if (Authenticate.getUser() == null) {
            throw CmsDomainException.forbiden();
        }
        this.setCreatedBy(Authenticate.getUser());
        this.setCreationDate(new DateTime());

    }

    /**
     * 
     * @return
     *         the name of the component.
     */
    public String getName() {
        return componentType().getAnnotation(ComponentType.class).name();
    }

    /**
     * 
     * @return
     *         the description of the component.
     */
    public String getDescription() {
        return componentType().getAnnotation(ComponentType.class).description();
    }

    /**
     * @return
     *         the type of the component.
     */
    @Override
    public String getType() {
        return componentType().getName();
    }

    /**
     * Provides the necessary info needed to render the component on a given page and context.
     * 
     * @param page
     *            the page where the component will be rendered.
     * @param componentContext
     *            local context for the component.
     * @param globalContext
     *            global context where the component is being rendered.
     */
    public abstract void handle(Page page, TemplateContext componentContext, TemplateContext globalContext);

    @Atomic(mode = TxMode.WRITE)
    public void delete() {
        this.setCreatedBy(null);
        for (Page page : getInstalledPageSet()) {
            page.removeComponents(this);
        }
        this.deleteDomainObject();
    }

    public Class<?> componentType() {
        return this.getClass();
    }
}
