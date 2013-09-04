<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="EventInfo" output="false" >

	<cfset this.eventType = "">
	<cfset this.projectInfo = "">
	
	<cffunction name="getEventType" output="false">
		<cfreturn this.eventType>
	</cffunction>
	
	<cffunction name="setEventType" output="false">
		<cfargument name="type" required="true" >
		<cfset this.eventType = arguments.type>
	</cffunction>
	
	<cffunction name="hasProjectInfo" returntype="boolean" output="false">
		<cfif this.projectInfo eq "">
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setProjectInfo" output="false">
		<cfargument name="info" required="true" type="ProjectInfo">
		
		<cfset this.projectInfo = arguments.info>
	</cffunction>
	
	<cffunction name="getProjectInfo" returntype="ProjectInfo" output="false">
		<cfreturn this.projectInfo>
	</cffunction>
	
</cfcomponent>