<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
--->
<cfsetting showDebugOutput = "no" >
<!---- load orm utility ---->

<cfset util = new "com.adobe.cfbuilder.orm-util"() />

<cfscript>
	ormTables = session.ormMgr.getTables();
	ormManager = session.ormMgr;
</cfscript>

<!---- generate ORM components ---->

<cftry>
	<cfdirectory action="create" directory="#ormManager.getLocation()#">
	<cfcatch>
		<!--- Ignore this --->
    </cfcatch>
</cftry>
<cftry>
	<cfset linkedTables = {}>
	<!--- This is kind of first pass thru all tables and relations in order to manipulate the table and relation objects
	before the actual code generation --->
	<cfloop array="#ormTables#" index="tableInfo">
		<cfset relations=tableInfo.getRelations()>
		<cfloop array="#relations#" index="relationInfo">
			<!--- Do not generate code for Linked Tables --->
			<cfset linkedTable = relationInfo.getLinkTable()>
			<cfif isDefined("linkedTable") && linkedTable neq "">
				<cfset structInsert(linkedTables,linkedTable,linkedTable,true)>
			</cfif>
			<cfif !isDefined("linkedTable") || linkedTable eq "">
			<!---
			Call for session.ormMgr.getFKColumn is done for two reasons
			1) In Case of Art and Artists example in example table in Apache Derby, FK constraint is not defined. So this call
			here will intelligently add FK to importedForeignKeys of the table so that <cfproperty> is not generated for the
			table. And this call is done here instead of in valueobj.cfc.cfm because <cfproperty> gets generated before the relation
			generation.
			2) For 1-1 relation, we dont support PK and FK same case. We support other case where in FK and PK are different. We
			infer the FK by analyzing the PK in the join for the relation. Moreover for 1-1 relation, Code in source and target
			table are different and dependent on eah other. One side should have fkcolumn and other side should have mappedby
			attribute. This call also helps to facilitate that.
			--->
				<cfset session.ormMgr.getFKColumn(tableinfo,relationInfo)>
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfset generateServices = session.ormMgr.isGenerateServices()>
	
	<cfif session.ormMgr.getscriptbased() eq "true" >
		<cfset util.writeTemplate(session.ormMgr.getLocation() & '/' & 'Application.cfc', 'orm/scriptapplication.cfc.cfm') />
		<cfloop array="#ormTables#" index="tableInfo">
			<cfif !structkeyexists(linkedTables,tableInfo.getTableName())>
				<cfset filename = session.ormMgr.getLocation() & '/' & tableInfo.getCFCName()>
				<cfset util.writeTemplate(filename & '.cfc', 'orm/scriptvalueobj.cfc.cfm', tableInfo) />
                <cfif generateServices eq true>
					<cfset util.writeTemplate(filename & 'Service.cfc', 'orm/scriptormservice.cfc.cfm', tableInfo) />
				</cfif>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset util.writeTemplate(session.ormMgr.getLocation() & '/' & 'Application.cfc', 'orm/application.cfc.cfm') />
		<cfloop array="#ormTables#" index="tableInfo">
			<cfif !structkeyexists(linkedTables,tableInfo.getTableName())>
				<cfset filename = session.ormMgr.getLocation() & '/' & tableInfo.getCFCName()>
				<cfset util.writeTemplate(filename & '.cfc', 'orm/valueobj.cfc.cfm', tableInfo) />
                <cfif generateServices eq true>
					<cfset util.writeTemplate(filename & 'Service.cfc', 'orm/ormservice.cfc.cfm', tableInfo) />
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfcatch type="any">
		<b>Code could not be generated</b>
		<cfdump var="#cfcatch#">
		<cfabort>
    </cfcatch>>
</cftry>
<cfoutput>
<b>Code generated successfully in #session.ormMgr.getLocation()#</b>
</cfoutput>



