<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<h1><spring:message code="theme.view.title"/></h1>

<b>${theme.name}</b>

<p>${theme.description}</p>

<div>Type:<code>${theme.type}</code></div>
<p>
<ul class="nav nav-tabs">
    <li class="active"><a href="#file" data-toggle="tab">Files <span class="badge">${cms.prettySize(theme.files.totalSize)}</span></a>
    </li>
    <li><a href="#templates" data-toggle="tab">Templates</a></li>
</ul>
</p>
<div class="tab-content">

    <div class="row tab-pane active" id="file">
        <div class="col-sm-12">

            <p>

            <div class="btn-group">
                <button class="btn btn-sm btn-default" data-toggle="modal" data-target="#fileNewModal">New File</button>
                <button class="btn btn-sm btn-default" data-toggle="modal" data-target="#fileImport">Import</button>
            </div>
            </p>

            <c:choose>
            <c:when test="${theme.files.files.size() > 0}">
            <table class="table table-striped table-bordered">
                <thead>
                <tr>
                    <th><spring:message code="theme.view.label.path"/></th>
                    <th><spring:message code="theme.view.label.size"/></th>
                    <th><spring:message code="theme.view.label.last.modification"/></th>
                    <th>&nbsp;</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="i" items="${theme.files.files}">
                    <tr>
                        <td><code title="${i.contentType}">${i.fullPath}</code></td>
                        <td>${cms.prettySize(i.fileSize)}</td>
                        <td>${i.lastModified.toString('dd-MM-YYYY HH:mm:ss')}</td>
                        <td>
                            <button class="btn btn-danger btn-sm" data-toggle="modal" data-file="${i.fullPath}"
                                    data-target="#fileDeleteModal">
                                <span class="glyphicon glyphicon-trash"></span>
                            </button>
                            <c:if test="${supportedTypes.contains(i.contentType)}">
                                <a href="editFile/${i.fullPath}" class="btn btn-default btn-sm"><spring:message
                                        code="action.edit"/></a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </c:when>
                <c:otherwise>
                    <i>Theme has no files</i>
                </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <div class="row tab-pane" id="templates">
        <div class="col-sm-12">
            <p>
                <button class="btn btn-sm btn-default">Create New Template</button>
            </p>
            <c:choose>
                <c:when test="${theme.templatesSet.size() > 0}">
                    <table class="table table-striped table-bordered">
                        <thead>
                        <tr>
                            <th class="col-md-6"><spring:message code="theme.view.label.name"/></th>
                            <th><spring:message code="theme.view.label.type"/></th>
                            <th><spring:message code="theme.view.label.path"/></th>
                            <th>&nbsp;</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="template" items="${theme.templatesSet}">
                            <tr>
                                <td>
                                    <h5>${template.name}</h5>

                                    <div>
                                        <small>${template.description}</small>
                                    </div>
                                </td>
                                <td><code>${template.type}</code></td>
                                <td><code>${template.filePath}</code></td>
                                <td>
                                    <button class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-trash"></span></button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <i>Theme has no templates</i>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
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
                <spring:message code="theme.view.label.delete.confirmation"/> <code id="fileName"></code>?
            </div>
            <div class="modal-footer">
                <form action="deleteFile" id="fileDeleteForm" method="POST">
                    <input type="hidden" name="path"/>
                    <button type="submit" class="btn btn-danger"><spring:message code="label.yes"/></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="label.no"/></button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="fileNewModal" tabindex="-1" role="dialog" aria-hidden="true">
    <form action="newFile" class="form-horizontal" method="post">
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
                            <input type="text" name="filename" class="form-control">

                            <p class="help-block">Use the full path, with directories, here.</p>
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

<div class="modal fade" id="templateNewModal" tabindex="-1" role="dialog" aria-hidden="true">
    <form action="newFile" class="form-horizontal" method="post">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                            class="sr-only">Close</span></button>
                    <h4><spring:message code="action.newTemplate"/></h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label"><spring:message
                                code="theme.view.fileName"/>:</label>

                        <div class="col-sm-10">
                            <input type="text" name="filename" class="form-control">

                            <p class="help-block">Use the full path, with directories, here.</p>
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

<div class="modal fade" id="fileImport" tabindex="-1" role="dialog" aria-hidden="true">
    <form action="importFile" enctype="multipart/form-data" class="form-horizontal" method="post">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                            class="sr-only">Close</span></button>
                    <h4><spring:message code="action.import"/></h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label"><spring:message
                                code="theme.view.fileName"/>:</label>

                        <div class="col-sm-10">
                            <input type="text" name="filename" class="form-control">

                            <p class="help-block">Use the full path, with directories, here.</p>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="inputEmail3" class="col-sm-2 control-label"><spring:message code="theme.add.label.file"/>:</label>

                        <div class="col-sm-10">
                            <input type="file" name="uploadedFile" class="form-control" id="inputEmail3" placeholder="Name">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary"><spring:message code="label.import"/></button>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    $("button[data-target='#fileDeleteModal']").on('click', function (event) {
        var fileName = $(event.target).attr('data-file');
        $('#fileName').html(fileName);
        $('#fileDeleteForm')[0].path.value = fileName;
    });
</script>