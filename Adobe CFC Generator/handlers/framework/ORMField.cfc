<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->
<cfcomponent output="false" extends="TableFieldInfo">
	<cfset this.cfcFieldType = "">
	<cfset this.cfcFieldName = "">
	<cfset this.isFK = false>
	<cfset this.Selected = false>

	<cffunction name="setCFCFieldName" output="false">
		<cfargument name="name">		
		<cfset this.CFCFieldname = arguments.name>
	</cffunction>
	
	<cffunction name="getCFCFieldName" output="false">
		<cfreturn this.CFCFieldname>
	</cffunction>
	
	<cffunction name="setCFCFieldType" output="false">
		<cfargument name="type">		
		<cfset this.CFCFieldtype = arguments.type>
    </cffunction>
    
	<cffunction name="getCFCFieldType" output="false">
		<cfreturn this.CFCFieldtype>
	</cffunction>

	<cffunction name="setIsFK" output="false">
		<cfargument name="fk">		
		<cfset this.isFK = arguments.fk>
    </cffunction>
    
	<cffunction name="getIsFK" output="false">
		<cfreturn this.isFK>
	</cffunction>
	
	<cffunction name="setSelected" output="false">
		<cfargument name="selected">		
		<cfset this.Selected = arguments.selected>
    </cffunction>
    
	<cffunction name="isSelected" output="false">
		<cfreturn this.Selected>
	</cffunction>
</cfcomponent>