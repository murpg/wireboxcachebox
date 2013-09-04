<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="TableInfo" output="false" >

	<cfset this.tableName = "">
	<cfset this.fields = ArrayNew(1)>

	<cffunction name="setTableName" output="false">
		<cfargument name="tableName" required="true" >
		
		<cfset this.tableName = arguments.tableName>
	</cffunction>
	
	<cffunction name="getTableName" output="false">
		<cfreturn this.tableName>
	</cffunction>
	
	<cffunction name="addField" output="false">
		<cfargument name="field" type="TableFieldInfo" required="true" >
		
		<cfset ArrayAppend(this.fields, field)>
	</cffunction>
	
	<cffunction name="getFields" returntype="Array" output="false">
		<cfreturn this.fields>
	</cffunction>
	
	<cffunction name="getField"  output="false">
        <cfargument name="fieldName" required="true">
        
        <cfloop array="#this.fields#" index="field">
            <cfif field.getName() eq arguments.fieldName>
                <cfreturn field>
            </cfif>
        </cfloop>
        <cfreturn "">
    </cffunction>
</cfcomponent>