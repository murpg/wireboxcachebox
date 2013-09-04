<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="Property" output="false" >

	<cfset this.name = "">
	<cfset this.value = "">
	
	<cffunction name="getName" output="false">
		<cfreturn this.name>
	</cffunction>
	
	<cffunction name="setName" output="false">
		<cfargument name="name">
		<cfset this.name = arguments.name>
	</cffunction>
	
	<cffunction name="getValue" output="false">
		<cfreturn this.value>
    </cffunction>
	
	<cffunction name="setValue" output="false">
		<cfargument name="value">
		<cfset this.value = arguments.value>
	</cffunction>
	
	<cffunction name="set" output="false">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true" >
		
		<cfset setName(arguments.name)>
		<cfset setValue(arguments.value)> 
	</cffunction>
	
</cfcomponent>