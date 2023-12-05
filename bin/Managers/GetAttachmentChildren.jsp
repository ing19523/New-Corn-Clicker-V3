<?xml version="1.0" encoding="UTF-8"?>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type = "com.ibm.commerce.content.facade.datatypes.AttachmentType[]"
     var="attachments"
     expressionBuilder="getAttachmentById">
     <wcf:contextData name="storeId" data="${param.storeId}" />
     <wcf:param name="attachmentId" value="${param.attachmentId}"/>
     <wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>


<objects>
<c:if test="${!(empty attachments)}">
	<c:forEach var="attachment" items="${attachments}">
		<jsp:directive.include file="serialize/SerializeAttachmentDescription.jspf"/>
	
        <c:if test="${!(empty attachment.attachmentAsset)}">
        	<c:forEach var="attachmentAsset" items="${attachment.attachmentAsset}">   
             
              <c:choose>
	               <c:when test="${(empty attachmentAsset.mimeType) || (attachmentAsset.mimeType == '')}">
	                      <object objectType="AttachmentAssetWithURLType">
	                            <assetId><wcf:cdata data="${attachmentAsset.attachmentAssetIdentifier.uniqueID}"/></assetId>
	                            
	                            <c:choose>
									<c:when test="${!( empty attachmentAsset.rootDirectory)}">
										<path><wcf:cdata data="${attachmentAsset.attachmentAssetPath}"/></path>
										<fileName><wcf:cdata data="${attachmentAsset.rootDirectory}"/></fileName>
								    </c:when>
								    <c:otherwise>
	      								<path><wcf:cdata data="${attachmentAsset.attachmentAssetPath}"/></path>
	 								</c:otherwise>
	 							</c:choose>
								
									<c:choose>
										 <c:when test= "${!( empty attachmentAsset.language)}">
								 	 		<c:set var="languageIds" value="" />
								     		<c:forEach var="languageId" items = "${attachmentAsset.language}" varStatus="varStatus">
								     			<c:choose>
													<c:when test="${!(varStatus.first)}">
								    	      			<c:set var="languageIds" value="${languageIds},${languageId}" />
								    	  		 	</c:when>
								    	     		<c:otherwise>
	      											 	<c:set var ="languageIds" value="${languageId}" />
	 												</c:otherwise>
	 											</c:choose>
								   			</c:forEach>
								   			<assetLanguageIds>${languageIds}</assetLanguageIds>
								   		</c:when>
								   </c:choose>
						  </object>		
				   </c:when>
	              <c:otherwise>
	              	<c:set var="attachmentAssetObjectType" value="AttachmentAssetWithFileType" /> 
	              	<c:set var="managedFileObjectType" value="ManagedFile" /> 
					<c:set var="owningStoreId" value="${attachmentAsset.storeIdentifier.uniqueID}" />
					<c:if test="${(param.storeId) != owningStoreId}">
						<c:set var="attachmentAssetObjectType" value="InheritedAttachmentAssetWithFileType" /> 
						<c:set var="managedFileObjectType" value="InheritedManagedFile" /> 
					</c:if>
					<c:set var="fullAttachmentAssetPath" value="/${attachmentAsset.rootDirectory}/${attachmentAsset.attachmentAssetPath}" />
					<wcf:getData type="com.ibm.commerce.content.facade.datatypes.ManagedFileType[]"
						var="managedFiles"
						expressionBuilder="findManagedFileByFilePath"
						varShowVerb="showVerb">
						<wcf:contextData name="storeId" data="${param.storeId}"/>
						<wcf:param name="filePath" value="${fullAttachmentAssetPath}"/>
					</wcf:getData>
					<c:if test="${!(empty managedFiles)}">
	                      <object objectType="${attachmentAssetObjectType}">
	                          <path><wcf:cdata data="${fullAttachmentAssetPath}"/></path>
	                          <assetId><wcf:cdata data="${attachmentAsset.attachmentAssetIdentifier.uniqueID}"/></assetId>
	                          <mimeType><wcf:cdata data="${attachmentAsset.mimeType}"/></mimeType>
	                          <c:forEach var="managedFile" items="${managedFiles}">
	                          	<jsp:directive.include file="serialize/SerializeManagedFile.jspf"/>
	                          </c:forEach>
	                          
								 <c:choose>
										 <c:when test= "${!( empty attachmentAsset.language)}">
								 	 		<c:set var="languageIds" value="" />
								     		<c:forEach var="languageId" items = "${attachmentAsset.language}" varStatus="varStatus">
								     			<c:choose>
													<c:when test="${!(varStatus.first)}">
								    	      			<c:set var="languageIds" value="${languageIds},${languageId}" />
								    	  		 	</c:when>
								    	     		<c:otherwise>
	      											 	<c:set var ="languageIds" value="${languageId}" />
	 												</c:otherwise>
	 											</c:choose>
								   			</c:forEach>
								   			<assetLanguageIds>${languageIds}</assetLanguageIds>
								   		</c:when>
								   	
								   </c:choose>
						  </object>
					</c:if>
	              </c:otherwise>
	         </c:choose>
	      </c:forEach>
	   </c:if>
    </c:forEach>
</c:if>
</objects>

