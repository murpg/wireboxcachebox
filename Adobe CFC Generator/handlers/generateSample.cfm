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

<cfif StructkeyExists(SESSION.settings.input,"remote") and SESSION.settings.input.remote EQ "true" >
	<cfset finpath=replace(expandpath("."),"FBSampleCodeGenerator",SESSION.settings.input.location)>
	<cfset SESSION.settings.input.location = "#finpath#">
</cfif>

<!---- set default settings ---->
<cfif NOT len(trim(SESSION.settings.input.servicename))>
	<!---- servicename defaults to datasource ---->
	<cfset SESSION.settings.input.servicename = SESSION.settings.input.datasource />
</cfif>

<cfset SESSION.mode = "CRUD" />
<cfscript>
	SESSION.options =
	{
		output=false,
		basepath = "http://" & #cgi.server_name# & ":" & #cgi.server_port# 
	};
</cfscript>

<cfswitch expression="#SESSION.mode#">
	
	<cfcase value="ORM">
		<!---- generate ORM components ---->
		<cfloop from="1" to="#arrayLen(SESSION.settings.table)#" index="t">
			<cfset filename = SESSION.settings.input.location & '/' & SESSION.settings.table[t].name />
			<cfset util.writeTemplate(filename & '.cfc', 'orm/valueobj.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
		</cfloop>
	</cfcase>
	
	<cfdefaultcase>
		<!---- generate CRUD components ---->
		<cfloop from="1" to="#arrayLen(SESSION.settings.table)#" index="t">
			<cfset filename = SESSION.settings.input.location & '/' & SESSION.settings.table[t].name />
			<cfset util.writeTemplate(filename & '.cfc', 'crud/valueobj.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfset util.writeTemplate(filename & 'DAO.cfc', 'crud/dao.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
			<cfset util.writeTemplate(filename & 'Gateway.cfc', 'crud/gateway.cfc.cfm', SESSION.settings.table[t], SESSION.settings.input) />
		</cfloop>
		
		<cfif not StructkeyExists(SESSION.settings.input,"generateService")>
				<cfset structinsert(SESSION.settings.input,"generateService","true")>
		</cfif>
		
		<cfif SESSION.settings.input.generateService>
			<cfset slen=Len(SESSION.settings.input.servicename)>
			<cfif slen GT 4 and  find(".cfc",SESSION.settings.input.servicename,slen-5) neq 0> 
		      <cfset SESSION.settings.input.servicename=Mid(SESSION.settings.input.servicename,1,slen-4)>
		   	</cfif>
			<cfset filename = SESSION.settings.input.location & '/' & SESSION.settings.input.servicename />
			<cfset util.writeTemplate(filename & '.cfc', 'flexservice.cfc.cfm', SESSION.settings, SESSION.settings.input) />
		</cfif>
	</cfdefaultcase>

</cfswitch>
	

