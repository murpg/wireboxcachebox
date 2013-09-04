<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
--->
<cfprocessingdirective suppressWhiteSpace = "Yes">
<cfsetting enablecfoutputonly="true" />
<cfparam name="tableinfo" />
<cfparam name="util">

<cfset fields = tableinfo.getFields()>
<cflog file="bolt" text="creating #tableinfo.getCFCName()# value object..." />

<cfoutput>component persistent="true" table="#tableinfo.getTableName()#" <cfif tableinfo.getSchema() neq ""><cfset schema="#tableinfo.getSchema()#"> schema="#trim(schema)#"</cfif> output="false"
{
	/* properties */
	<cfloop array="#fields#" index="ormField"><cfif ormField.isSelected() && !structkeyexists(tableinfo.getImportedForeignKeys(),ormField.getName())>
	property name="#ormField.getCFCFieldName()#" column="#ormField.getName()#" type="#ormField.getCFType()#" ormtype="#ormField.getCFCFieldType()#"<cfif #ormField.isPrimaryKey()#> fieldtype="id"</cfif>;</cfif>
	</cfloop>
	<cfset relations = tableinfo.getRelations()>
	<cfloop array="#relations#" index="relation">
		<cfset multiplicity = util.getRelationMultiplicity(relation.getmultiplicity())>
		<cfset linkTable = relation.getLinkTable()>
		<cfset targetTableInfo = session.ormMgr.getTableInfo(relation.gettargetTable())>
		<cfset targetschema = targetTableInfo.getSchema()>
		<cfset targetcfc = targetTableInfo.getCFCName()>
		<cfif isDefined("linkTable") && linkTable neq "">
			<cfset linkedTableFKs = session.ormMgr.getFKColumnForLinkedTable(tableinfo,relation)>
		<cfelse>
			<cfset fkcol = session.ormMgr.getFKColumn(tableinfo,relation)>
			<cfif relation.getmultiplicity() eq "1-1">
				<cfif relation.getFKcolSideFor1to1Relation() eq 3>
					<cfset fkcol = javacast("null","")>
					<cfset mappedby = relation.getMappedby()>
				</cfif>
			</cfif>
		</cfif>
	property name="#relation.getrelationName()#"<cfif relation.getmultiplicity() eq "1-n" || relation.getmultiplicity() eq "m-n">type="array"</cfif> fieldtype="#trim(multiplicity)#" cfc="#trim(targetcfc)#"<cfif isDefined("fkcol")> fkcolumn="#fkcol#"</cfif><cfif isdefined("linkTable") && linkTable neq ""> linktable="#trim(linkTable)#"</cfif><cfif isDefined("linkedTableFKs")> fkcolumn="#listFirst(linkedTableFKs,",")#" inversejoincolumn="#listLast(linkedTableFKs,",")#"</cfif><cfif isdefined("mappedby") && mappedby neq ""> mappedby="#trim(mappedby)#"</cfif>;
	</cfloop>	
}</cfoutput>
<cfsetting enablecfoutputonly="false" />
</cfprocessingdirective>