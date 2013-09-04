<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="OutlineInfo" output="false" >

	<cfset this.projectName = "">
	<cfset this.projectLocation = "">
	<cfset this.sourceFileName = "">
	<cfset this.sourceFilePath = "">
	<cfset this.nodes = arraynew(1)>
	
	<cffunction name="getProjectName" output="false">
		<cfreturn this.projectName>
	</cffunction>
	
	<cffunction name="setProjectName" output="false">
		<cfargument name="name" required="true" >
		
		<cfset this.projectName = arguments.name>
	</cffunction>
	
	<cffunction name="getProjectLocation" output="false">
		<cfreturn this.projectLocation>
	</cffunction>
	
	<cffunction name="setProjectLocation" output="false">
		<cfargument name="location" required="true" >
		
		<cfset this.projectLocation = arguments.location>
	</cffunction>
	
	<cffunction name="getSourceFileName" output="false">
		<cfreturn this.sourceFileName>
	</cffunction>
	
	<cffunction name="setSourceFileName" output="false">
		<cfargument name="name" required="true" >
		
		<cfset this.sourceFileName = arguments.name>
	</cffunction>
		 
	<cffunction name="getSourceFilePath" output="false">
		<cfreturn this.sourceFilePath>
	</cffunction>
	
	<cffunction name="setSourceFilePath" output="false">
		<cfargument name="path" required="true" >
		
		<cfset this.sourceFilePath = arguments.path>
	</cffunction>
	
	<cffunction name="addNodeInfo" output="false">
		<cfargument name="nodeInfo" type="OutlineNodeInfo" required="true" >
		
		<cfset ArrayAppend(this.nodes, nodeInfo)>
	</cffunction>
	
	<cffunction name="getNodes" returntype="Array" output="false">
		<cfreturn this.nodes>
	</cffunction>
	
</cfcomponent>