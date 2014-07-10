package org.fenixedu.bennu.cms.domain;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.fenixedu.bennu.core.domain.User;
import org.fenixedu.bennu.core.security.Authenticate;
import org.fenixedu.bennu.core.util.CoreConfiguration;
import org.joda.time.DateTime;

import pt.ist.fenixframework.Atomic;
import pt.ist.fenixframework.consistencyPredicates.ConsistencyPredicate;

import com.google.common.collect.Lists;

/**
 * Models the items of a {@link Menu}
 */
public class MenuItem extends MenuItem_Base implements Comparable<MenuItem> {
    
    /**
     * The logged {@link User} creates a new MenuItem.
     */
    public MenuItem() {
        super();
        if(Authenticate.getUser() == null){
            throw new RuntimeException("Needs Login");
        }
        this.setCreatedBy(Authenticate.getUser());
        this.setCreationDate(new DateTime());
    }
    
    /**
     * Adds a children at a given position and shifts the existing items.
     * 
     * @param item
     *            the {@link MenuItem} to be added.
     * @param position
     *            the position where the item should be added.
     */
    public void putAt(MenuItem item, int position) {

        if (item.getPosition() != null) {
            item.removeFromParent();
        }

        if (position < 0){
            position = 0;
        } else if (position > getChildrenSet().size()) {
            item.removeFromParent();
            position = getChildrenSet().size();
        }
        
        List<MenuItem> list = Lists.newArrayList(getChildrenSorted());
        list.add(position, item);
        
        fixOrder(list);

        getChildrenSet().add(item);
    }

    /**
     * Removes a given {@link MenuItem}
     * 
     * @param mi
     *            the children to be removed
     */
    public void remove(MenuItem mi){
        ArrayList<MenuItem> items = Lists.newArrayList(getChildrenSorted());
        items.remove(mi);
        fixOrder(items);
        getChildrenSet().remove(mi);
    }
    
    /**
     * Adds a new {@link MenuItem} has the last item.
     * 
     * @param mi
     *            the {@link MenuItem} to be added.
     */
    public void add(MenuItem mi){
        this.putAt(mi, getChildrenSet().size());
    }

    /**
     * Removes the {@link MenuItem} from its parent.
     * <p>
     * The Parent can be a {@link Menu} or a {@link MenuItem}
     * </p>
     */
    public void removeFromParent(){
        if (this.getTop() != null){
            this.getTop().remove(this);
        }else if(this.getParent() != null){            
            this.getParent().remove(this);
        }
    }

    /**
     * @return the childrens sorted by position
     */
    public List<MenuItem> getChildrenSorted(){
        return getChildrenSet().stream().sorted(Comparator.naturalOrder()).collect(Collectors.toList());
    }
    
    /**
     * @return the URL address to visit the item.
     */
    public String getAddress(){
        if (getUrl() != null){
            return getUrl();
        } else {
            String path = CoreConfiguration.getConfiguration().applicationUrl();
            if (path.charAt(path.length()-1) != '/') {
                path += "/";
            }
            path += this.getMenu().getSite().getSlug() + "/" + this.getPage().getSlug();
            return path;
        }
    }
    
    /**
     * A MenuItem can not be linked with a {@link Menu} and a {@link MenuItem} at the same time
     */
    @ConsistencyPredicate
    public boolean parentOrTop() {
        return !(getTop() != null && getParent() != null);
    }

    @Atomic
    public void delete(){
        this.removeFromParent();
        getChildrenSet().stream().forEach(c -> c.delete());
        this.setParent(null);
        this.setCreatedBy(null);
        this.setMenu(null);
        this.setPage(null);
        this.setTop(null);
        this.deleteDomainObject();
    }

    @Override
    public int compareTo(MenuItem o) {
        return getPosition() - o.getPosition();
    }

    @Override
    public Integer getPosition() {
        return Optional.ofNullable(super.getPosition()).orElse(0);
    }

    public static void fixOrder(List<MenuItem> sortedItems) {
        for (int i = 0; i < sortedItems.size(); ++i) {
            sortedItems.get(i).setPosition(i);
        }
    }
}
