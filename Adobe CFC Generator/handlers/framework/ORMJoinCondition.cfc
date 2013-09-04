<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
--->
<cfcomponent>
	<cfset this.sourceField = "">
	<cfset this.targetField = "">
	
	<cffunction name="setsourceField" output="false">
		<cfargument name="name">		
		<cfset this.sourceField = arguments.name>
	</cffunction>
	
	<cffunction name="getsourceField" output="false">
		<cfreturn this.sourceField>
	</cffunction>

	<cffunction name="settargetField" output="false">
		<cfargument name="name">		
		<cfset this.targetField = arguments.name>
	</cffunction>
	
	<cffunction name="gettargetField" output="false">
		<cfreturn this.targetField>
	</cffunction>

</cfcomponent>