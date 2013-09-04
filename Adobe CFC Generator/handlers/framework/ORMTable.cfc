<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->
<cfcomponent output="false" extends="TableInfo">
	<cfset variables.cfcName ="">
	<cfset variables.relations =[]>
	<cfset variables.importedForeignKeys = {}>
	<cfset variables.exportedForeignKeys = {}>
	<cfset variables.schema= "">

	<cffunction name="setSchema">
		<cfargument name="schema" required="true" >
		<cfset variables.schema = ARGUMENTS.schema>
	</cffunction>
	
	<cffunction name="getSchema">
		<cfreturn variables.schema>
	</cffunction>	

	<cffunction name="setImportedForeignKeys">
		<cfargument name="importedForeignKeys" required="true" >
		<cfset variables.importedForeignKeys = ARGUMENTS.importedForeignKeys>
	</cffunction>
	
	<cffunction name="addImportedForeignKey">
		<cfargument name="fk" required="true" >
		<cfset structInsert(variables.importedForeignKeys,fk,fk,true)>
	</cffunction>
		
	<cffunction name="getImportedForeignKeys">
		<cfreturn variables.importedForeignKeys>
	</cffunction>	
	
	<cffunction name="setExportedForeignKeys">
		<cfargument name="exportedForeignKeys" required="true" >
		<cfset variables.exportedForeignKeys = ARGUMENTS.exportedForeignKeys>
	</cffunction>
	
	<cffunction name="getExportedForeignKeys">
		<cfreturn variables.exportedForeignKeys>
	</cffunction>	
		
	<cffunction name="addORMField">
		<cfargument name="field" required="true" >
		<cfset addField(arguments.field)>
	</cffunction>
	
	<cffunction name="getRelations">
		<cfreturn variables.relations>
	</cffunction>
	
	<cffunction name="addRelation">
		<cfargument name=newRelation required=true>
		<cfset ArrayAppend(variables.relations,newRelation)>
	</cffunction>
	
	<cffunction name="removeAllRelations">
		<cfset arrayClear(variables.relations)>
	</cffunction>
	
	<cffunction name="restTalbeForCodeGeneration">
        <!--- remove all relations --->
        <cfset removeAllRelations()>
        <!--- unselect all fields --->
        <cfloop array="#this.getFields()#" index="field">
            <cfset field.setSelected(false)>
        </cfloop>    
	</cffunction>
	
	<cffunction name="getCFCName"><cfreturn variables.CFCName>
	</cffunction>
	
	<cffunction name="setCFCName">
		<cfargument name="name" required="true" >
		<cfset variables.CFCName = name>
	</cffunction>
	
	<cffunction name="getPrimaryKeys">
		<cfset var keys = []>
		<cfloop array="#getfields()#" index="local.ormField">
			<cfif local.ormField.isPrimaryKey()>
				<cfset arrayappend(keys,local.ormField)>
			</cfif>
		</cfloop>
		<cfreturn keys/>
    </cffunction>	

	<cffunction name="isPrimaryKey" returntype="boolean">
		<cfargument name="column" required="true">
		<cfloop array="#getfields()#" index="local.ormField">
			<cfif local.ormField.getName() eq column>
				<cfreturn local.ormField.isPrimaryKey()>
			</cfif>
		</cfloop>
		<cfreturn false>
    </cffunction>		
	
	<cffunction name="getFieldNames"> 
		<cfset var fieldAry = []>
		<cfloop array="#this.getFields()#" index="local.fieldInfo">
			<cfset arrayAppend(fieldAry,this.getTableName()&"."&local.fieldInfo.getName())>
        </cfloop>
		<cfloop collection="#this.getImportedForeignKeys()#" item="local.key">
			<cfset arrayAppend(fieldAry,this.getTableName()&"."&local.key)>
        </cfloop>		
		<cfreturn fieldAry>
    </cffunction>
</cfcomponent>