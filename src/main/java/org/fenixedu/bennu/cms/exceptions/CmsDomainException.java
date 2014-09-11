package org.fenixedu.bennu.cms.exceptions;

import javax.ws.rs.core.Response;

import org.fenixedu.bennu.core.domain.exceptions.DomainException;

/**
 * Created by nurv on 22/08/14.
 */
public class CmsDomainException extends DomainException {

    protected static final String BUNDLE = "CmsExceptionResources";

    protected CmsDomainException(Response.Status status, String bundle, String key, String... args) {
        super(status, bundle, key, args);
    }

    public static CmsDomainException forbiden() {
        return new CmsDomainException(Response.Status.FORBIDDEN, BUNDLE, "error.not.authorized");
    }

    public static CmsDomainException notFound() {
        return new CmsDomainException(Response.Status.NOT_FOUND, BUNDLE, "error.not.found");
    }
}
