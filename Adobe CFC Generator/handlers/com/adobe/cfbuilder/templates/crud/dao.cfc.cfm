<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfsetting enablecfoutputonly="true" />
<cfparam name="settings" type="struct" default="#structNew()#" />
<cfparam name="input" type="struct" default="#structNew()#" />


<cfoutput><:cfcomponent output="false">

	<!-- Auto-generated method
		         Add authroization or any logical checks for secure access to your data -->
	<!-- init -->
	<:cffunction name="init" returntype="any">
		<:cfreturn this />
	</:cffunction>
	
	<!-- create -->
	<:cffunction name="create" returntype="any">
		<cfloop from="1" to="#arrayLen(settings.field)#" index="i"><:cfargument name="#settings.field[i].column#" type="#settings.field[i].cftype#" required="true" /></cfloop>
		
		<!-- Auto-generated method
		         Add authroization or any logical checks for secure access to your data -->
		<:cfset var IdentityCol="" />
		<:cfset var qry="" />	
		<!--TODO:  Below code is for table without auto increment enabled for primary key .Change the query Appropriately-->
		<!-- insert record -->
		<:cfquery name="qry" datasource="#input.datasource#">
			INSERT INTO #settings.name#
			(
				<cfloop from="1" to="#arrayLen(settings.field)#" index="i">#lCase(settings.field[i].column)#<cfif i NEQ arrayLen(settings.field)>,</cfif><cfif NOT i mod 5>#linebreak(1)##tab(4)#</cfif></cfloop>
			)
			VALUES
			(
				<cfloop from="1" to="#arrayLen(settings.field)#" index="i"><:cfqueryparam cfsqltype="#settings.field[i].cfsqltype#" value="##ARGUMENTS.#settings.field[i].column###" null="false" /><cfif i NEQ arrayLen(settings.field)>,#linebreak(1)##tab(4)#</cfif></cfloop>
			)
		</:cfquery>
		
		<cfset pset="false">
		<cfloop from="1" to="#arrayLen(settings.field)#" index="i">
			<cfif settings.field[i].isprimarykey >
		<:cfif arguments.#settings.field[i].column# NEQ ''>
			<:cfset IdentityCol=arguments.#settings.field[i].column#>
					<cfset pset="true">
				<cfbreak>
			</cfif>
		</cfloop>
	  	<cfif pset EQ "false">
	  	<:cfif arguments.#settings.field[1].column# NEQ ''>
	  		<:cfset IdentityCol="arguments.#settings.field[1].column#">
		</cfif>      
		<:cfelse>
		<!--TODO: This logic is for diffrent db's.Delete the conditions not applicable -->	 
      	<:cfif IsDefined("qry.GENERATEDKEY")>
            <:cfset identityCol = qry.GENERATEDKEY>
		<:cfelseif IsDefined("qry.IDENTITYCOL")><!-- SQL Server only-->	
            <:cfset identityCol = qry.IDENTITYCOL>
      	<:cfelseif IsDefined("qry.GENERATED_KEY")> <!-- MySQL only-->
            <:cfset identityCol = qry.GENERATED_KEY>
      	<:cfelseif IsDefined("qry.GENERATED_KEYS")>
            <:cfset identityCol = qry.GENERATED_KEYS>
      	<:cfelseif IsDefined("qry.ROWID")><!-- Oracle only -->
            <:cfset identityCol = qry.ROWID>
      	<:cfelseif IsDefined("qry.SYB_IDENTITY")><!-- Sybase only -->
            <:cfset identityCol = qry.SYB_IDENTITY>
      	<:cfelseif IsDefined("qry.SERIAL_COL")> <!--Informix only-->
            <:cfset identityCol = qry.SERIAL_COL>
      	<:cfelseif IsDefined("qry.KEY_VALUE")>
            <:cfset identityCol = qry.KEY_VALUE>
      	</:cfif>
		
	  	</:cfif>	
		<!-- return IdentityCol -->
		<:cfreturn IdentityCol />
	</:cffunction>
	
	
	<!-- read -->
	<:cffunction name="read" returntype="#settings.file#">
		<:cfargument name="id" type="any" required="true" />
		
		<!-- Auto-generated method
		         Add authroization or any logical checks for secure access to your data -->
		<:cfset var obj = createObject('component', '#settings.file#').init() />
		<:cfset var i = 1 />
		<:cfset var qry="" />
		<cfset firstKey = true />
		<:cfquery name="qry" datasource="#input.datasource#">
			SELECT <cfloop from="1" to="#arrayLen(settings.field)#" index="i">#lCase(settings.field[i].column)#<cfif i NEQ arrayLen(settings.field)>,</cfif><cfif NOT i mod 5>#linebreak(1)##tab(5)#</cfif></cfloop>
			FROM #settings.name#
			where <cfloop from="1" to="#arrayLen(settings.key)#" index="i"><cfif !firstKey>#linebreak(1)##tab(4)#AND </cfif>#lCase(settings.key[i].column)# = <:cfqueryparam cfsqltype="#settings.key[i].cfsqltype#" value="##ARGUMENTS.id##" null="false" /><cfset firstKey = "true" /></cfloop>
		</:cfquery>
		<!-- load value object -->
		<cfloop from="1" to="#arrayLen(settings.field)#" index="i"><:cfset obj.set#settings.field[i].column#(qry.#settings.field[i].column#[i]) />
		</cfloop><!-- return success -->
		<:cfreturn obj />
	</:cffunction>
	
	<!-- update -->
	<:cffunction name="update" returntype="void">
		<cfloop from="1" to="#arrayLen(settings.field)#" index="i"><:cfargument name="#settings.field[i].column#" type="#settings.field[i].cftype#" required="true" />#iif(i LT arrayLen(settings.field), de(linebreak(1) & tab(2)), de(''))#</cfloop>
		<!-- Auto-generated method
		         Add authroization or any logical checks for secure access to your data -->
		<cfset firstKey = true />
		<:cfset var qry="" />
		<!-- update database -->
		<:cfquery name="qry" datasource="#input.datasource#">
			UPDATE #settings.name#
			SET <cfloop from="1" to="#arrayLen(settings.field)#" index="i"><cfif !settings.field[i].isPrimaryKey>#lCase(settings.field[i].column)# = <:cfqueryparam cfsqltype="#settings.field[i].cfsqltype#" value="##ARGUMENTS.#settings.field[i].column###" null="false" /><cfif i NEQ arrayLen(settings.field)>,#linebreak(1)##tab(4)#</cfif></cfif></cfloop>
			WHERE <cfloop from="1" to="#arrayLen(settings.key)#" index="i"><cfif !firstKey>#linebreak(1)##tab(4)#AND </cfif>#lCase(settings.key[i].column)# = <:cfqueryparam cfsqltype="#settings.key[i].cfsqltype#" value="##ARGUMENTS.#settings.key[i].column###" null="false" /><cfset firstKey = "true" /></cfloop>
		</:cfquery>
		<!-- return success -->
		<:cfreturn />
	</:cffunction>
	
	<!-- delete -->
	<:cffunction name="delete" returntype="void">
		<cfset firstKey = true /><cfloop from="1" to="#arrayLen(settings.field)#" index="i"><cfif settings.field[i].isPrimaryKey><cfif !firstKey>#linebreak(1)##tab(2)#</cfif><:cfargument name="#settings.field[i].column#" type="#settings.field[i].cftype#" required="true" /><cfset firstKey = "true" /></cfif></cfloop>
		<!-- Auto-generated method
		         Add authroization or any logical checks for secure access to your data -->
		<:cfset var qry="" />
		<!-- delete from database -->
		<:cfquery name="qry" datasource="#input.datasource#">
			DELETE FROM #settings.name#
			WHERE <cfloop from="1" to="#arrayLen(settings.key)#" index="i"><cfif !firstKey>#linebreak(1)##tab(4)#AND </cfif>#lCase(settings.key[i].column)# = <:cfqueryparam cfsqltype="#settings.key[i].cfsqltype#" value="##ARGUMENTS.#settings.key[i].column###" null="false" /><cfset firstKey = "true" /></cfloop>
		</:cfquery>
		<!-- return success -->
		<:cfreturn />
	</:cffunction>

</:cfcomponent></cfoutput>
<cfsetting enablecfoutputonly="false" />