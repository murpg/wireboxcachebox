<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="RequestProcessor" output="false" >
	
	<cffunction name="parseRequest" output="false" access="public" returntype="RequestInfo" >
		<cfargument name="eventInfoXML" required="true" type="XML" >
		
		<cfset var result = createObject("component","RequestInfo")>
		
		<cfset extractProjectInfo(eventInfoXML,result)>
		
		<cfset extractUserFields(eventInfoXML, result)>
		
		<cfset extractRDSInfo(eventInfoXML,result)>

		<cfset extractEditorInfo(eventInfoXML,result)>

		<cfset extractOutlineInfo(eventInfoXML,result)>
		
		<cfset extractEventInfo(eventInfoXML, result)>
		
		<cfreturn result>
		
    </cffunction>
	
	<cffunction name="extractProjectInfo" access="private" output="false">
		<cfargument name="eventInfoXML" required="true" type="XML" >
		<cfargument name="requestInfo" type="RequestInfo" required="true" >

		<cfset var projectViewNode = xmlsearch(eventInfoXML,"/event/ide/projectview")>
		
		<cfif isDefined("projectViewNode") and ArrayLen(projectViewNode) gt 0 >
		
			<cfset projectName = projectViewNode[1].XMLAttributes.projectname>
			<cfset projectPath = projectViewNode[1].XMLAttributes.projectlocation>
			<cfset projectInfo = createObject("component","ProjectInfo")>
			
			<cfset projectInfo.setProjectName(projectName)>
			<cfset projectInfo.setProjectLocation(projectPath)>
			<cfset requestInfo.setProjectInfo(projectInfo)>
			
			<cfif StructKeyExists(projectViewNode[1], "resource")>
				<cfset resources = projectViewNode[1].resource>
				<cfloop index="i" from="1" to="#ArrayLen(resources)#" >
					<cfset resourcePath = resources[i].XMLAttributes.path>
					<cfset type = resources[i].XMLAttributes.type>
					<cfset resourceInfo = createObject("component","ResourceInfo")>
					<cfset resourceInfo.set(resourcePath,type)>
					<cfset projectInfo.addProjectResource(resourceInfo)>
				</cfloop>
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="extractUserFields" access="private" output="false">
		<cfargument name="eventInfoXML" required="true" type="XML" >
		<cfargument name="requestInfo" type="RequestInfo" required="true" >

		<cfset var userFields = xmlSearch(eventInfoXML, "/event/user")>
		
		<cfif isDefined("userFields") and ArrayLen(userFields) gt 0>
			<cfif StructKeyExists(userFields[1],"input")>
				<cfset inputs = userFields[1].input>
				<cfloop index="i" from="1" to="#ArrayLen(inputs)#" >
					<cfset name = inputs[i].XMLAttributes.name>
					<cfset value = inputs[i].XMLAttributes.value>
					<cfset propInfo = createObject("component","Property")>
					<cfset propInfo.set(name,value)>
					<cfset requestInfo.addUserDefinedFiled(propInfo)>
				</cfloop>
			</cfif>
		</cfif>

	</cffunction>	
	
	<cffunction name="extractRDSInfo" access="private" output="false">
		<cfargument name="eventInfoXML" required="true" type="XML" >
		<cfargument name="requestInfo" type="RequestInfo" required="true" >

		<cfset var rdsInfo = xmlSearch(eventInfoXML, "/event/ide/rdsview")>
		
		
		<cfif isDefined("rdsInfo") and ArrayLen(rdsInfo) gt 0>
			<cfset rdsInfoComp = createObject("component", "RDSInfo")>
			<cfset requestInfo.setRDSInfo(rdsInfoComp)>
			
			<cfset dbName = rdsInfo[1].database[1].XMLAttributes.name>
			<cfset rdsInfoComp.setDatabaseName(dbName)>
			
			<cfif structkeyExists(rdsInfo[1].database[1],"table")>
				<cfloop index="tableIndex" from="1" to="#ArrayLen(rdsInfo[1].database[1].table)#">
					<cfset tableComp = createObject("component", "TableInfo")>
					<cfset rdsInfoComp.addTable(tableComp)>
					<cfset tableInfo = rdsInfo[1].database[1].table[tableIndex]>
					<cfset tableComp.setTableName(tableInfo.XMLAttributes.name)>
					
					<cfif structkeyExists(tableInfo,"fields")>

						<cfif StructKeyExists(tableInfo.fields[1],"field")>
							<cfset fieldInfos = tableInfo.fields[1].field>
							<cfloop index="i" from="1" to="#ArrayLen(fieldInfos)#">
								<cfset fieldName = fieldInfos[i].XMLattributes.name>
								<cfset fieldType = fieldInfos[i].XMLattributes.type>
								<cfset fieldLength = fieldInfos[i].XMLattributes.length>
								<cfif StructKeyexists(fieldInfos[i].XMLattributes,"cftype")>
									<cfset cfType = fieldInfos[i].XMLattributes.cftype>
								<cfelse>
									<cfset cfType = "">
								</cfif>
								<cfif StructKeyexists(fieldInfos[i].XMLattributes, "cfsqltype")>
									<cfset cfSQLType = fieldInfos[i].XMLattributes.cfsqltype>
								<cfelse>
									<cfset cfSQLType = "">
								</cfif>
								<cfif StructKeyexists(fieldInfos[i].XMLattributes, "javatype")>
									<cfset javaType = fieldInfos[i].XMLattributes.javatype>
								<cfelse>
									<cfset javaType = "">
								</cfif>
								<cfif StructKeyexists(fieldInfos[i].XMLattributes, "primarykey")>
									<cfset isPrimaryKey = fieldInfos[i].XMLattributes.primarykey>
								<cfelse>
									<cfset isPrimaryKey = false>
								</cfif>
								<cfif StructKeyexists(fieldInfos[i].XMLattributes, "nullallowed")>
									<cfset isNullAllowed = fieldInfos[i].XMLattributes.nullallowed>
								<cfelse>
									<cfset isNullAllowed = true>
								</cfif>
								<cfset fieldInfo = createObject("component", "TableFieldInfo")>
								<cfset fieldInfo.set(fieldName,fieldType,fieldLength,cfType,cfSQLType,javaType,isPrimaryKey,isNullAllowed)>
								<cfset tableComp.addField(fieldInfo)>
		                    </cfloop>
						</cfif>
							
					</cfif>
					
                </cfloop>			
			</cfif>
			
		</cfif>
		
	</cffunction>

	<cffunction name="extractEditorInfo" access="private" output="true">
		<cfargument name="eventInfoXML" required="true" type="XML" >
		<cfargument name="requestInfo" type="RequestInfo" required="true" >

		<cfset var editorInfo = xmlSearch(eventInfoXML, "/event/ide/editor")>
		
		<cfif isDefined("editorInfo") and ArrayLen(editorInfo) gt 0>
			<cfset editorInfoComp = createObject("component", "EditorInfo")>
			<cfset requestInfo.setEditorInfo(editorInfoComp)>
			
			<cfif structkeyExists(editorInfo[1], "file")>
				<cfset fileInfo = editorInfo[1].file>
				<cfset editorInfoComp.setFilePath(fileInfo.XmlAttributes.location)>
				<cfset editorInfoComp.setFileName(fileInfo.XMLAttributes.name)>
				<cfset editorInfoComp.setProjectName(fileInfo.XMLAttributes.project)>
				<cfset editorInfoComp.setProjectLocation(fileInfo.XMLAttributes.projectlocation)>
				<cfset editorInfoComp.setProjectRelativeLocation(fileInfo.XMLAttributes.projectrelativelocation)>
			</cfif>
			
			<cfif structkeyExists(editorInfo[1], "selection")>
				<cfset selectionInfo = editorInfo[1].selection>
				<cfset editorInfoComp.setSelectionStartColumn(selectionInfo.XMLAttributes.startcolumn)>
				<cfset editorInfoComp.setSelectionEndColumn(selectionInfo.XMLAttributes.endcolumn)>
				<cfset editorInfoComp.setSelectionStartLine(selectionInfo.XMLAttributes.startline)>
				<cfset editorInfoComp.setSelectionEndLine(selectionInfo.XMLAttributes.endline)>
				<cfset editorInfoComp.setSelectedText(selectionInfo.text.xmlText)>
			</cfif>
		</cfif>
		
	</cffunction>
	
	<cffunction name="extractOutlineInfo" access="private" output="false">
		<cfargument name="eventInfoXML" required="true" type="XML" >
		<cfargument name="requestInfo" type="RequestInfo" required="true" >

		<cfset var outlineInfo = xmlSearch(eventInfoXML, "/event/outlineview")>
		
		
		<cfif isDefined("outlineInfo") and ArrayLen(outlineInfo) gt 0>
			<cfset outlineInfoComp = createObject("component", "OutlineInfo")>
			<cfset requestInfo.setOutlineInfo(outlineInfoComp)>
			
			<cfset projectName = outlineInfo[1].XMLAttributes.projectname>
			<cfset projectLocation = outlineInfo[1].XMLAttributes.projectlocation>
			
			<cfset outlineInfoComp.setProjectName(projectName)>
			<cfset outlineInfoComp.setProjectLocation(projectLocation)>
			
			<cfif StructkeyExists(outlineInfo[1],"source")>
				<cfset sourceInfo = outlineInfo[1].source>
				<cfset fileName = outlineInfo[1].source[1].XMLAttributes.filename>
				<cfset path = outlineInfo[1].source[1].XMLAttributes.path>
				<cfset outlineInfoComp.setSourceFileName(filename)>
				<cfset outlineInfoComp.setsourceFilePath(path)>
				
				<cfset nodes = outlineInfo[1].source[1].node>
				<cfif isDefined("nodes") and ArrayLen(nodes) gt 0>
					<cfloop index="nodeIndex" from="1" to="#ArrayLen(nodes)#">
						<cfset nodeType = nodes[nodeIndex].XMLAttributes.type>
						<cfset nodeInfoComp = createObject("component", "OutlineNodeInfo")>
						<cfset nodeInfoComp.setNodeType(nodeType)>
						<cfset outlineInfoComp.addNodeInfo(nodeInfoComp)>
						
						<cfset nodeFunction = nodes[1].function>
						<cfif isDefined("nodeFunction") and ArrayLen(nodeFunction)>
							<cfset nodeFuncName = nodeFunction[1].XMLAttributes.name>
							<cfset nodeFuncRetType = nodeFunction[1].XMLAttributes.returntype>
							<cfset functionComp = createObject("component", "FunctionInfo")>
							<cfset functionComp.setFunctionName(nodeFuncName)>
							<cfset functionComp.setReturnType(nodeFuncRetType)>
							<cfset nodeInfoComp.setFunctionInfo(functionComp)>
							
							<cfset nodeFuncArgs = nodeFunction[1].argument>
							<cfif isDefined("nodeFuncArgs") and ArrayLen(nodeFuncArgs) gt 0>
								<cfloop index="argIndex" from="1" to="#ArrayLen(nodeFuncArgs)#">
									<cfset nodeFuncArgName = nodeFuncArgs[argIndex].XMLAttributes.name>
									<cfset nodeFuncArgType = nodefuncArgs[argIndex].XMLAttributes.type>
									<cfset argComp = createObject("component", "ArgumentInfo")>
									<cfset argComp.setName(nodeFuncArgName)>
									<cfset argComp.setType(nodeFuncArgType)>
									<cfset functionComp.addArgument(argComp)>
                                </cfloop>
							</cfif>	
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>	
	</cffunction>


	<cffunction name="extractEventInfo" access="private" output="false">
		<cfargument name="eventInfoXML" required="true" type="XML" >
		<cfargument name="requestInfo" type="RequestInfo" required="true" >

		<cfset var eventInfoNode = xmlsearch(eventInfoXML,"/event/eventinfo")>
		
		<cfif isDefined("eventInfoNode") and ArrayLen(eventInfoNode) gt 0 >
		
			<cfset eventType = eventInfoNode[1].XMLAttributes.eventtype>
			<cfset eventComp = createObject("component", "EventInfo")>
			<cfset eventComp.setEventType(eventType)>
			<cfset requestInfo.setEventInfo(eventComp)>
			
			<cfset projectName = eventInfoNode[1].XMLAttributes.projectname>
			<cfset projectPath = eventInfoNode[1].XMLAttributes.projectlocation>
			<cfset projectInfo = createObject("component","ProjectInfo")>
			
			<cfset projectInfo.setProjectName(projectName)>
			<cfset projectInfo.setProjectLocation(projectPath)>
			<cfset eventComp.setProjectInfo(projectInfo)>
			
			<cfset resources = eventInfoNode[1].resource>
			<cfif isDefined("resources") and ArrayLen(resources) gt 0>
				<cfloop index="i" from="1" to="#ArrayLen(resources)#" >
					<cfset resourcePath = resources[i].XMLAttributes.path>
					<cfset type = resources[i].XMLAttributes.type>
					<cfset resourceInfo = createObject("component","ResourceInfo")>
					<cfset resourceInfo.set(resourcePath,type)>
					<cfset projectInfo.addProjectResource(resourceInfo)>
				</cfloop>
			</cfif>
		</cfif>

	</cffunction>

</cfcomponent>