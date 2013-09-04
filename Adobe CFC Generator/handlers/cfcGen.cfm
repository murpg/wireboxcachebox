<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfparam name="ideeventinfo" />

<!---- load extension utility ---->
<cfset util = createObject("component", "com.adobe.cfbuilder.ext-util") />

<!---- create extension sessions ---->
<cfset SESSION = {} />
<cfset SESSION.settings = util.parseIDEEventInfo(ideeventinfo) />

<cfif not StructkeyExists(SESSION.settings.input,"compat")>
	<cfset structinsert(SESSION.settings.input,"compat","true")>
</cfif>

<cfset SESSION.mode = "CRUD" />
<cfscript>
	SESSION.options =
	{
		output=false,
		basepath = "http://" & #cgi.server_name# & ":" & #cgi.server_port# 
	};
</cfscript>

		<!---- generate CRUD components ---->
	<cfif SESSION.settings.input.scriptbased eq "true" >
		<cfloop from="1" to="#arrayLen(SESSION.settings.table)#" index="t">
			<cfset filename = SESSION.settings.input.location & '/' & SESSION.settings.table[t].name />
			<cfset util.writeTemplate(filename & '.cfc', 'crud/scriptvalueobj.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfset util.writeTemplate(filename & 'DAO.cfc', 'crud/scriptdao.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfset util.writeTemplate(filename & 'Gateway.cfc', 'crud/scriptgateway.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfif SESSION.settings.input.generateService>
				<cfset util.writeTemplate(filename & 'Service.cfc', 'scriptflexservice.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop from="1" to="#arrayLen(SESSION.settings.table)#" index="t">
			<cfset filename = SESSION.settings.input.location & '/' & SESSION.settings.table[t].name />
			<cfset util.writeTemplate(filename & '.cfc', 'crud/valueobj.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfset util.writeTemplate(filename & 'DAO.cfc', 'crud/dao.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfset util.writeTemplate(filename & 'Gateway.cfc', 'crud/gateway.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfif SESSION.settings.input.generateService>
				<cfset util.writeTemplate(filename & 'Service.cfc', 'flexservice.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			</cfif>
		</cfloop>
	</cfif>

