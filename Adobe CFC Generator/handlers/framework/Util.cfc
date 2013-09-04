<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="Util" output="false" >
	
	<cfset this.javaString = createObject("java", "java.lang.String")>
	 

	<cffunction name="getArrayCount" returntype="numeric" output="false">
		<cfargument name="arrayVar" type="Any" >

		<cfif isArray(arguments.arrayVar)>
			<cfreturn ArrayLen(arguments.arrayVar)>
		<cfelse>
			<cfreturn 0>
		</cfif>
    </cffunction>

	<cffunction name="generateURL" output="false">
		<cfargument name="templateName" required="true" type="string" >
		
		<cfreturn getURLBasePath() & "/" & templateName>
	</cffunction>
	
	<cffunction name="getURLBasePath" output="false" >
		<cfset scriptPath = CGI.script_name>
		<cfset javaStrObj = createJavaString(scriptPath)>
		<cfset index = javaStrObj.lastIndexOf("/")>
		<cfset scriptPath = javaStrObj.subString(0,index)>
		
		<cfreturn "http://"&#CGI.SERVER_NAME# &":" &#CGI.SERVER_PORT# & scriptPath>
    </cffunction>
	
	<cffunction name="createJavaString" returntype="any" output="false" >
		<cfargument name="arg" required="true" >
		<cfreturn this.javaString.init(arg)>		
	</cffunction>
	
	<cffunction name="createRefreshFileCommand" returntype="String" output="false" >
		<cfargument name="filePath" required="true" type="string" >
		<cfargument name="projectName" required="false" type="string" >
		
		<cfoutput>
			<cfsavecontent variable="result">
				<command type="refreshFile">
					<params>
						<param key="filename" value="#arguments.filePath#" />
						<cfif isDefined("arguments.projectName")>
						<param key="projectname" value="#arguments.projectName#" />
						</cfif>
					</params>
				</command>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn result>
	</cffunction> 

	<cffunction name="createRefreshFolderCommand" returntype="String" output="false" >
		<cfargument name="folderPath" required="true" type="string" >
		<cfargument name="projectName" required="false" type="string" >
		
		<cfoutput>
			<cfsavecontent variable="result">
				<command type="refreshFolder">
					<params>
						<param key="foldername" value="#arguments.folderPath#" />
						<cfif isDefined("arguments.projectName")>
						<param key="projectname" value="#arguments.projectName#" />
						</cfif>
					</params>
				</command>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn result>
	</cffunction> 

	<cffunction name="createRefreshProjectCommand" returntype="String" output="false" >
		<cfargument name="projectName" required="true" type="string" >
		
		<cfoutput>
			<cfsavecontent variable="result">
				<command type="refreshProject">
					<params>
						<param key="projectname" value="#arguments.projectName#" />
					</params>
				</command>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn result>
	</cffunction> 

	<cffunction name="createOpenFileCommand" returntype="String" output="false" >
		<cfargument name="filePath" required="true" type="string" >
		<cfargument name="projectName" required="false" type="string" >
		
		<cfoutput>
			<cfsavecontent variable="result">
				<command type="openFile">
					<params>
						<param key="filename" value="#arguments.filePath#" />
						<cfif isDefined("arguments.projectName")>
						<param key="projectname" value="#arguments.projectName#" />
						</cfif>
					</params>
				</command>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn result>
	</cffunction> 

	<cffunction name="createInsertTextCommand" returntype="String" output="false" >
		<cfargument name="text" required="true" type="string" >
		<cfargument name="insertMode" required="false" type="string" default="replace">
		
		<cfoutput>
			<cfsavecontent variable="result">
				<command type="inserttext">
					<params>
						<param key="text">
							<![CDATA[ #arguments.text# ]]>
						</param>
						<param key="insertmode" value="#arguments.insertMode#" />
					</params>
				</command>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn result>
	</cffunction> 

	<cffunction name="createWrapTextCommand" returntype="String" output="false" >
		<cfargument name="startText" required="true" type="string" >
		<cfargument name="endText" required="true" type="string" >
		
		<cfoutput>
			<cfsavecontent variable="result">
				<command type="inserttext">
					<params>
						<param key="starttext">
							<![CDATA[ #arguments.startText# ]]>
						</param>
						<param key="endtext">
							<![CDATA[ #arguments.endText# ]]>
						</param>
						<param key="insertmode" value="wrap" />
					</params>
				</command>
			</cfsavecontent>
		</cfoutput>
		
		<cfreturn result>
	</cffunction> 

</cfcomponent>
