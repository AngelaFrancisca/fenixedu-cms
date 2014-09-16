<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<h1><spring:message code="post.edit.title" /></h1>
<div class="row">
    <div class="col-sm-8"><h4>${site.name.content}</h4></div>
    <div class="col-sm-4">
        <div class="pull-right">
        <a href="${pageContext.request.contextPath}/cms/posts/${site.slug}" class="btn btn-default">Dashboard</a> <a href="${site.fullUrl}" target="_blank" class="btn btn-default">View Site</a> <a href="${post.address}" target="_blank" class="btn btn-default">View Post</a>
        </div>
    </div>
</div>
<form class="form-horizontal" action="" method="post" role="form">

<!-- Nav tabs -->
<ul class="nav nav-tabs" role="tablist">
    <li class="active"><a href="#postContent" role="tab" data-toggle="tab">Post</a></li>
    <li><a href="#files" role="tab" data-toggle="tab">Post Files</a></li>
    <li><a href="#attachments" role="tab" data-toggle="tab">Attachments</a></li>

</ul>

<!-- Tab panes -->
<div class="tab-content">
    <div class="tab-pane active" id="postContent">
        <p>
        </p>

            <div class="${emptyName ? "form-group has-error" : "form-group"}">
                <label for="inputEmail3" class="col-sm-2 control-label"><spring:message code="site.edit.label.slug"/></label>

                <div class="col-sm-5">
                    <div class="input-group">

                        <span class="input-group-addon"><code>/${site.baseUrl}/${site.viewPostPage.slug}/</code></span>
                        <input required type="text" name="newSlug" class="form-control" id="inputEmail3"
                               placeholder="<spring:message code="site.edit.label.slug" />" value='${post.slug}' \>
                    </div>
                </div>
            </div>

            <div class="${emptyName ? "form-group has-error" : "form-group"}">
                <label for="inputEmail3" class="col-sm-2 control-label"><spring:message code="post.edit.label.name" /></label>
                <div class="col-sm-10">
                    <input  bennu-localized-string required-any name="name" id="inputEmail3" placeholder="<spring:message code="post.edit.label.name" />" value='${post.name.json()}'>
                    <c:if test="${emptyName != null}"><p class="text-danger"><spring:message code="post.edit.error.emptyName"/></p></c:if>
                </div>
            </div>


            <div class="form-group">
                <label for="inputEmail3" class="col-sm-2 control-label"><spring:message code="post.edit.label.body" /></label>
                <div class="col-sm-10">
                    <textarea bennu-html-editor bennu-localized-string name="body" rows="3">${post.body.json()}</textarea>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-default btn-primary"><spring:message code="action.edit" /></button>
                </div>
            </div>

    </div>

    <div class="tab-pane" id="files">
        <div class="col-sm-12">
            <p>
            </p>
            <p>
                <button class="btn btn-default" data-toggle="modal" data-target="#addFile">Add File</button>
            </p>

            <c:choose>
                <c:when test="${post.postFiles.files.size() > 0}">
                    <table class="table table-striped table-bordered">
                        <thead>
                        <tr>
                            <th class="center">#</th>
                            <th class="col-md-6"><spring:message code="theme.view.label.name"/></th>
                            <th><spring:message code="theme.view.label.type"/></th>
                            <th>&nbsp;</th>

                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="file" items="${post.postFiles.files}" varStatus="loop">
                            <tr>
                                <td class="center">
                                    <h5>${loop.index + 1}</h5>
                                </td>

                                <td>
                                    <a href="${cms.downloadUrl(file)}" target="_blank"><h5>${file.displayName}</h5></a>
                                </td>

                                <td><code>${file.contentType}</code></td>
                                <td>
                                    <a href="#" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#fileDeleteModal"
                                            data-file="${file.displayName}" data-file-oid="${file.oid}" ><span class="glyphicon glyphicon-trash"></span></a>
                                    <a href="${cms.downloadUrl(file)}" target="_blank" class="btn btn-default btn-sm">Link</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <i>Post has no files</i>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="tab-pane" id="attachments">
            <div class="col-sm-12">
                <p>
                </p>
                <p>
                    <button class="btn btn-default" data-toggle="modal" data-target="#addAttachment">Add Attachment</button>
                </p>

                <c:choose>
                    <c:when test="${post.attachments.files.size() > 0}">
                        <table class="table table-striped table-bordered">
                            <thead>
                            <tr>
                                <th class="center">#</th>
                                <th class="col-md-6"><spring:message code="theme.view.label.name"/></th>
                                <th><spring:message code="theme.view.label.type"/></th>
                                <th>&nbsp;</th>

                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="file" items="${post.attachments.files}" varStatus="loop">
                                <tr>
                                    <td class="center">
                                        <h5>${loop.index + 1}</h5>
                                    </td>
                                    <td>
                                        <a href="${cms.downloadUrl(file)}" target="_blank"><h5>${file.displayName}</h5></a>

                                    </td>
                                    <td><code>${file.contentType}</code></td>
                                    <td>
                                        <button class="btn btn-danger btn-sm" data-toggle="modal" data-target="#attachmentDeleteModal"
                                                data-file="${file.displayName}" data-file-index="${loop.index}" ><span class="glyphicon glyphicon-trash"></span></button>
                                        <a href="${cms.downloadUrl(file)}" target="_blank" class="btn btn-default btn-sm">Link</a>

                                        <button class="btn btn-default btn-sm" data-toggle="modal" data-target="#attachmentDeleteModal"
                                                data-file="${file.displayName}" data-file-index="${loop.index}" >
                                            <spring:message code="label.access.control"/>
                                        </button>

                                        <div class="btn-group">

                                        <c:choose>
                                            <c:when test="${loop.index != 0}">
                                                <button class="btn btn-default btn-sm" data-origin="${loop.index}" data-destiny="${loop.index - 1}"><span class="glyphicon glyphicon-chevron-up"></span></button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-default disabled btn-sm"><span class="glyphicon glyphicon-chevron-up"></span></button>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${loop.index != post.attachments.files.size() -1}">
                                                <button class="btn btn-default btn-sm" data-origin="${loop.index}" data-destiny="${loop.index + 1}"><span class="glyphicon glyphicon-chevron-down"></span></button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-default disabled btn-sm" data-toggle="modal"><span class="glyphicon glyphicon-chevron-down"></span></button>
                                            </c:otherwise>
                                        </c:choose>

                                        </div>

                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <i>Post has no attachments</i>
                    </c:otherwise>
                </c:choose>
            </div>

    </div>
</div>

</form>

<form action="moveAttachment" id="moveAttachment" class="hidden" method="post">
    <input type="hidden" name="origin" value="${loop.index}"/>
    <input type="hidden" name="destiny" value="${loop.index + 1}"/>
    <button class="btn btn-default btn-sm" ><span class="glyphicon glyphicon-chevron-down"></span></button>
</form>

<div class="modal fade" id="addAttachment" tabindex="-1" role="dialog" aria-hidden="true">
    <form action="addAttachment" enctype="multipart/form-data" class="form-horizontal" method="post">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                            class="sr-only">Close</span></button>
                    <h4><spring:message code="action.new"/></h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label"><spring:message
                                code="theme.view.fileName"/>:</label>

                        <div class="col-sm-10">
                            <input required type="text" name="name" class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label"><spring:message
                                code="theme.add.label.file"/>:</label>

                        <div class="col-sm-10">
                            <input type="file" name="attachment" class="form-control" >
                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary"><spring:message code="label.make"/></button>
                </div>
            </div>
        </div>
    </form>
</div>

<div class="modal fade" id="attachmentDeleteModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4><spring:message code="action.delete"/></h4>
            </div>
            <div class="modal-body">
                <spring:message code="theme.view.label.delete.confirmation"/> <b id="fileName"></b>?
            </div>
            <div class="modal-footer">
                <form action="deleteAttachment" id="deleteAttachment" method="POST">
                    <input type="hidden" name="file"/>
                    <button type="submit" class="btn btn-danger"><spring:message code="label.yes"/></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="label.no"/></button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addFile" tabindex="-1" role="dialog" aria-hidden="true">
    <form action="addFile" enctype="multipart/form-data" class="form-horizontal" method="post">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                            class="sr-only">Close</span></button>
                    <h4><spring:message code="action.new"/></h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label"><spring:message
                                code="theme.add.label.file"/>:</label>

                        <div class="col-sm-10">
                            <input type="file" name="attachment" class="form-control" >
                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary"><spring:message code="label.make"/></button>
                </div>
            </div>
        </div>
    </form>
</div>

<div class="modal fade" id="fileDeleteModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                        class="sr-only">Close</span></button>
                <h4><spring:message code="action.delete"/></h4>
            </div>
            <div class="modal-body">
                <spring:message code="theme.view.label.delete.confirmation"/> <b id="fileName"></b>?
            </div>
            <div class="modal-footer">
                <form action="deleteFile" id="deleteFile" method="POST">
                    <input type="hidden" name="file"/>
                    <button type="submit" class="btn btn-danger"><spring:message code="label.yes"/></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="label.no"/></button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $("[data-target='#attachmentDeleteModal']").on('click', function (event) {
        var index = $(event.target).closest("[data-file-index]").attr('data-file-index');
        var filename = $(event.target).closest("[data-file]").attr('data-file');
        $('#fileName').html(filename);
        $('#deleteAttachment')[0].file.value = index;
    });
</script>

<script>
    $("[data-target='#fileDeleteModal']").on('click', function (event) {
        var index = $(event.target).closest("[data-file-oid]").attr('data-file-oid');
        var filename = $(event.target).closest("[data-file]").attr('data-file');
        $('#fileName', $("#fileDeleteModal")).html(filename);
        $('#deleteFile')[0].file.value = index;
    });
</script>

<script>
    $("[data-origin]").on("click",function(e){
        e = $(e.target).closest("[data-origin]")
        var form = $("#moveAttachment")[0];
        form.origin.value = e.data("origin");
        form.destiny.value = e.data("destiny");
        form.submit();
    });
</script>

<script>
    setTimeout(function(){
        if (window.location.hash === "#attachments") {
            var z = $("[href='#attachments']")
            z.tab('show')
        }
    },150)
</script>

<script>
    setTimeout(function(){
        if (window.location.hash === "#files") {
            var z = $("[href='#files']")
            z.tab('show')
        }
    },150)
</script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/font-awesome.css"/>
<script src="${pageContext.request.contextPath}/static/js/toolkit.js"></script>


<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/toolkit/toolkit.css"/>
