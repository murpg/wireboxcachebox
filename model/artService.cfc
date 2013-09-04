﻿<cfcomponent name="artService" output="false">
<cfproperty name="art" inject="ID:art" scope="instance">
<cfproperty name="artDAO" inject="ID:artDAO" scope="instance">
<cfproperty name="artGateway" inject="ID:artGateway" scope="instance">
<cfproperty name="log" inject="logbox:logger:model.artService" />
	<cffunction name="init" access="public" output="false" returntype="artService">
		<cfreturn this/>
	</cffunction>
	<cffunction name="createart" access="public" output="false" returntype="art">
		<cfargument name="ARTID" type="string" required="true" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
		
		<cfset var art = instance.art.init(argumentCollection=arguments) />
		<cfreturn art />
	</cffunction>

	<cffunction name="getart" access="public" output="false" returntype="art">
		<cfargument name="ARTID" type="string" required="false" />
		<cfset var art = "" />
		<cfset var result = "" />
		<cfset log.INFO(message="ID Passed In:  #arguments.toString()#",extrainfo='Top of the method', severity='INFO') />
		
		<cfset  art = createart(argumentCollection=arguments) />
		
		<cfset result = instance.artDAO.read(art)/>
		
		<cfset log.INFO(message=serializeJSON(result),extrainfo='Items returned by method', severity='INFO') />
		
		<cfreturn result />
	</cffunction>

	<cffunction name="getArts" access="public" output="false" returntype="query">
		<cfargument name="datatype" type="string" required="false" default="query" hint="query or array" >
		<cfargument name="ARTID" type="string" required="false" />
		<cfargument name="ARTISTID" type="string" required="false" />
		<cfargument name="ARTNAME" type="string" required="false" />
		<cfargument name="DESCRIPTION" type="string" required="false" />
		<cfargument name="PRICE" type="numeric" required="false" />
		<cfargument name="LARGEIMAGE" type="string" required="false" />
		<cfargument name="MEDIAID" type="string" required="false" />
		<cfargument name="ISSOLD" type="numeric" required="false" />
		
		<cfif arguments.datatype eq "query">
			<cfreturn instance.artGateway.getByAttributesQuery(argumentCollection=arguments) />
		<cfelse>
			<cfreturn instance.artGateway.getByAttributes(argumentCollection=arguments) />
		</cfif>
	</cffunction>

	<cffunction name="saveart" access="public" output="false" returntype="boolean">
		<cfargument name="art" type="art" required="true" />

		<cfreturn instance.artDAO.save(art) />
	</cffunction>

	<cffunction name="deleteart" access="public" output="false" returntype="boolean">
		<cfargument name="ARTID" type="string" required="true" />
		
		<cfset var art = createart(argumentCollection=arguments) />
		<cfreturn instance.artDAO.delete(art) />
	</cffunction>
</cfcomponent>