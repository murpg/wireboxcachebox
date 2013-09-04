<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="ProjectInfo" output="false" >

	<cfset this.projectName = "">
	<cfset this.projectLocation = "">
	<cfset this.projectResources = ArrayNew(1)>
	
	<cffunction name="setProjectName" output="false">
		<cfargument name="name">
		<cfset this.projectName = arguments.name>
    </cffunction>
	
	<cffunction name="getProjectName" output="false">
		<cfreturn this.projectName>
    </cffunction>
	
	<cffunction name="setProjectLocation" output="false">
		<cfargument name="location">
		<cfset this.projectLocation = arguments.location>
	</cffunction>
	
	<cffunction name="getProjectLocation" output="false">
		<cfreturn this.projectLocation>
	</cffunction>
	
	<cffunction name="addProjectResource" output="false">
		<cfargument name="resource" type="ResourceInfo">
		<cfset ArrayAppend(this.projectResources, resource)>
    </cffunction>
	
	<cffunction name="getProjectResources" returntype="Array" output="false">
		<cfreturn this.projectResources>
    </cffunction>
	
</cfcomponent>