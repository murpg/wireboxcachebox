<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="ArgumentInfo" output="false" >
	
	<cfset this.name = "">
	<cfset this.type = "">
	
	<cffunction name="getName" output="false" >
		<cfreturn this.name>
	</cffunction>
	
	<cffunction name="setName" output="false">
		<cfargument name="name">
		
		<cfset this.name = arguments.name>
	</cffunction>
	
	<cffunction name="getType" output="false">
		<cfreturn this.type>
	</cffunction>
	
	<cffunction name="setType" output="false">
		<cfargument name="type">
		
		<cfset this.type = arguments.type>
	</cffunction>
	
</cfcomponent>