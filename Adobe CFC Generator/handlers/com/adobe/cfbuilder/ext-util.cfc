<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent hint="Utility Functions For Extending Bolt" output="false">

	<cffunction name="writeTemplate" returntype="void" access="public">
		<cfargument name="destination" type="string" required="true" />
		<cfargument name="template" type="string" required="true" />
		<cfargument name="settings" type="struct" required="true" />
		<cfargument name="input" type="struct" required="true" />
		<cfset var file = "" />
		
		
		<!---- generate file ---->
		<cfsavecontent variable="file"><cfinclude template="templates/#ARGUMENTS.template#" /></cfsavecontent>
		<!---- parse cf prefix ---->
		<cfset file = reReplaceNoCase(file, ':cf', 'cf', 'all') />
		<!---- convert comments ---->
		<cfset file = reReplaceNoCase(file, '<!--', '<!----', 'all') />
		<cfset file = reReplaceNoCase(file, '-->', '---->', 'all') />
		<!---- remove double linebreaks ---->
		<cfset file = reReplaceNoCase(file, chr(10) & chr(10), chr(10), 'all') />
		<!---- write to disk --->
		<cffile action="write" output="#file#" file="#ARGUMENTS.destination#" fixnewline="yes" />
		
		<!---- return success ---->
		<cfreturn />
	</cffunction>

	<cffunction name="parseIDEEventInfo" returntype="struct" access="public">
		<cfargument name="xml" type="string" required="true" />
		<cfset extxml= xmlParse(ARGUMENTS.xml)>
		
		<cfset extsys = {}>
		<cfset dsarr=ArrayNew(1)>
		<cfset extxmlinput = xmlSearch(extxml, "/event/user/input")>
		<cfset extxmltable ="">
		<!--<cfset extsys.input = {}>-->
		<cfloop index="i" from="1" to="#arrayLen(extxmlinput)#" >
			<cfset StructInsert(extsys.input,"#extxmlinput[i].xmlAttributes.name#","#extxmlinput[i].xmlAttributes.value#")>
		</cfloop>
		
		<cfset dsarr=xmlSearch(extxml, "/event/ide/rdsview/database")>
		<cfset extsys.input.datasource = dsarr[1].XMLAttributes.name>
		<!---<cfset extsys.input.database = getDBType(extsys.input.datasource)>--->
		<cfset extsys.table = []>
		<cfset extxmltable = xmlSearch(extxml, "/event/ide/rdsview/database/table")>
		
		<cfloop index="i" from="1" to="#arrayLen(extxmltable)#">
			<cfif(find('.',extxmltable[i].xmlAttributes.name))>
				<cfset extxmltable[i].xmlAttributes.name = getToken(extxmltable[i].xmlAttributes.name, 2, '.')>
			</cfif>
			<cfset table = StructNew()>
			<cfset table.name=extxmltable[i].xmlAttributes.name>
			<cfset table.table=extxmltable[i].xmlAttributes.name>
			<cfset table.file=tCase(extxmltable[i].xmlAttributes.name)>
			<cfset table.field=[]>
			<cfif( StructkeyExists(extsys.input,"fromfb"))>
				<cfset table.field = getColumns(extxmltable[i].fields.field,"true")>
			<cfelse>
				<cfset table.field = getColumns(extxmltable[i].fields.field,"false")>
			</cfif>
			<cfset table.key = []>
			<cfset table.foreign = []>
			<cfloop index="j" from="1" to="#arrayLen(table.field)#">
				<cfif(table.field[j].isPrimaryKey)>
					<cfset arrayAppend(table.key, table.field[j])>
				</cfif>
				<cfif table.field[j].isForeignKey >
				<cfset arrayAppend(table.foreign, table.field[j])>
				</cfif>
		
			</cfloop>
			
			<cfset arrayAppend(extsys.table, table)>
		</cfloop>
			
		<!---- return success ---->
		<cfreturn extsys />		
	</cffunction>
	
	<cffunction name="getColumns" returntype="array">
		<cfargument name="fields" required="true" type=xml />
		<cfargument name="fromfb" default="false" />

		<cfset var i = 0 />
		<!---- query column information ---->
<!---		<cfdbinfo type="Columns" datasource="#ARGUMENTS.datasource#" table="#ARGUMENTS.table#" name="tableinfo" />--->
		<cfset columns=ArrayNew(1)>
		<!---- convert to array ---->
		<cfloop from="1" to="#ArrayLen(fields)#" index="i">
			<cfset column = {} />
			<cfset column.column = fields[i].xmlattributes.name />
			<cfset column.name = tCase(fields[i].xmlattributes.name) />
			<cfset column.type = fields[i].xmlattributes.type />
			<cfset column.length = fields[i].xmlattributes.length />
			<cfset column.isPrimaryKey = fields[i].xmlattributes.primarykey />
			<cfset column.isForeignKey = "false" />
			<cfset column.cftype =fields[i].xmlattributes.cftype  />
			<cfset column.cfsqltype=fields[i].xmlattributes.cfsqltype />
			<cfset arrayAppend(columns, column) />
		</cfloop>
		<cfreturn columns />
	</cffunction>
	
	<cffunction name="getDBType" returntype="struct">
		<cfargument name="datasource" required="true" />
		
		<cfset var q = queryNew('unknown') />
		<cfset var dbinfo = {} />
		<!---- query db information ---->
		<cfdbinfo datasource="#ARGUMENTS.datasource#" type="Version" name="q" />
		<!---- populate db info struct ---->
		<cfif q.recordcount>
			<cfset dbinfo.type = q.database_productname[1] />
			<cfset dbinfo.version = q.database_version[1] />
			<cfset dbinfo.drivee = q.driver_name[1] />
		</cfif>
		<!---- return success ---->
		<cfreturn dbinfo />
	</cffunction>
	
	
	<cfscript>
		INSTANCE.datatype = {};
		INSTANCE.datatype.INTEGER = 'numeric';
		INSTANCE.datatype.INT = 'numeric';
		INSTANCE.datatype.BIGINT = 'numeric';
		INSTANCE.datatype.SMALLINT = 'numeric';
		INSTANCE.datatype.TINYINT = 'numeric';
		INSTANCE.datatype.DECIMAL = 'numeric';
		INSTANCE.datatype.DOUBLE = 'numeric';
		INSTANCE.datatype.FLOAT = 'numeric';
		INSTANCE.datatype.MONEY = 'numeric';
		INSTANCE.datatype.MONEY4 = 'numeric';
		INSTANCE.datatype.NUMERIC = 'numeric';
		INSTANCE.datatype.BIT = 'boolean';
		INSTANCE.datatype.DATE = 'date';
		INSTANCE.datatype.TIME = 'string';
		INSTANCE.datatype.TIMESTAMP = 'string';
		INSTANCE.datatype.CLOB = 'string';
		INSTANCE.datatype.BLOB = 'binary';
		INSTANCE.datatype.VARCHAR = 'string';
		INSTANCE.datatype.LONGVARCHAR = 'string';
		INSTANCE.datatype.VARCHAR = 'string';
		INSTANCE.datatype.CHAR = 'string';
		
		function getCFDatatype(arg)
		{
		   
			if(structKeyExists(INSTANCE.datatype, ARGUMENTS.arg)){return INSTANCE.datatype[ARGUMENTS.arg];}
			else{return "any";}
		}

		function tab(num)
		{
			var output = '';
			var i = 0;
			//if(!isNumeric(ARGUMENTS.num)){ARGUMENTS.num = 1;}
			for(i = 1; i LTE ARGUMENTS.num; i++)
			{
				output = output & chr(9);
			}
			return output;
		}
		
		function linebreak(num)
		{
			var output = '';
			var i = 0;
			//if(!isNumeric(ARGUMENTS.num)){ARGUMENTS.num = 1;}
			for(i = 1; i LTE ARGUMENTS.num; i++)
			{
				output = output & chr(10);
			}
			return output;
		}
		
		function tCase(arg)
		{
			ARGUMENTS.arg = ucase(ARGUMENTS.arg);
			return reReplace(ARGUMENTS.arg,"([[:upper:]])([[:upper:]]*)","\1\L\2\E","all");
		}
	</cfscript>

</cfcomponent>