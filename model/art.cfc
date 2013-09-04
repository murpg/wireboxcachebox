﻿<cfcomponent displayname="art" output="false">
		<cfproperty name="ARTID" type="string" default="" />
		<cfproperty name="ARTISTID" type="string" default="" />
		<cfproperty name="ARTNAME" type="string" default="" />
		<cfproperty name="DESCRIPTION" type="string" default="" />
		<cfproperty name="PRICE" type="numeric" default="" />
		<cfproperty name="LARGEIMAGE" type="string" default="" />
		<cfproperty name="MEDIAID" type="string" default="" />
		<cfproperty name="ISSOLD" type="numeric" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="art" output="false">
		<cfargument name="ARTID" type="string" required="false" default="" />
		<cfargument name="ARTISTID" type="string" required="false" default="" />
		<cfargument name="ARTNAME" type="string" required="false" default="" />
		<cfargument name="DESCRIPTION" type="string" required="false" default="" />
		<cfargument name="PRICE" type="string" required="false" default="" />
		<cfargument name="LARGEIMAGE" type="string" required="false" default="" />
		<cfargument name="MEDIAID" type="string" required="false" default="" />
		<cfargument name="ISSOLD" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setARTID(arguments.ARTID) />
		<cfset setARTISTID(arguments.ARTISTID) />
		<cfset setARTNAME(arguments.ARTNAME) />
		<cfset setDESCRIPTION(arguments.DESCRIPTION) />
		<cfset setPRICE(arguments.PRICE) />
		<cfset setLARGEIMAGE(arguments.LARGEIMAGE) />
		<cfset setMEDIAID(arguments.MEDIAID) />
		<cfset setISSOLD(arguments.ISSOLD) />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="art" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="validate" access="public" returntype="array" output="false">
		<cfset var errors = arrayNew(1) />
		<cfset var thisError = structNew() />
		
		<!--- ARTID ---> <cfif (len(trim(getARTID())) AND NOT IsSimpleValue(trim(getARTID())))>
			<cfset thisError.field = "ARTID" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ARTID is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getARTID())) GT 10)>
			<cfset thisError.field = "ARTID" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "ARTID is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- ARTISTID --->
		<cfif (NOT len(trim(getARTISTID())))>
			<cfset thisError.field = "ARTISTID" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "ARTISTID is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getARTISTID())) AND NOT IsSimpleValue(trim(getARTISTID())))>
			<cfset thisError.field = "ARTISTID" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ARTISTID is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getARTISTID())) GT 10)>
			<cfset thisError.field = "ARTISTID" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "ARTISTID is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- ARTNAME --->
		<cfif (NOT len(trim(getARTNAME())))>
			<cfset thisError.field = "ARTNAME" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "ARTNAME is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getARTNAME())) AND NOT IsSimpleValue(trim(getARTNAME())))>
			<cfset thisError.field = "ARTNAME" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ARTNAME is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getARTNAME())) GT 50)>
			<cfset thisError.field = "ARTNAME" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "ARTNAME is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- DESCRIPTION --->
		<cfif (NOT len(trim(getDESCRIPTION())))>
			<cfset thisError.field = "DESCRIPTION" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "DESCRIPTION is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getDESCRIPTION())) AND NOT IsSimpleValue(trim(getDESCRIPTION())))>
			<cfset thisError.field = "DESCRIPTION" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "DESCRIPTION is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getDESCRIPTION())) GT 2147483647)>
			<cfset thisError.field = "DESCRIPTION" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "DESCRIPTION is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- PRICE --->
		<cfif (NOT len(trim(getPRICE())))>
			<cfset thisError.field = "PRICE" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "PRICE is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getPRICE())) AND NOT isNumeric(trim(getPRICE())))>
			<cfset thisError.field = "PRICE" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "PRICE is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- LARGEIMAGE --->
		<cfif (NOT len(trim(getLARGEIMAGE())))>
			<cfset thisError.field = "LARGEIMAGE" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "LARGEIMAGE is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getLARGEIMAGE())) AND NOT IsSimpleValue(trim(getLARGEIMAGE())))>
			<cfset thisError.field = "LARGEIMAGE" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "LARGEIMAGE is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getLARGEIMAGE())) GT 30)>
			<cfset thisError.field = "LARGEIMAGE" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "LARGEIMAGE is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- MEDIAID --->
		<cfif (NOT len(trim(getMEDIAID())))>
			<cfset thisError.field = "MEDIAID" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "MEDIAID is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getMEDIAID())) AND NOT IsSimpleValue(trim(getMEDIAID())))>
			<cfset thisError.field = "MEDIAID" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "MEDIAID is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getMEDIAID())) GT 10)>
			<cfset thisError.field = "MEDIAID" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "MEDIAID is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- ISSOLD --->
		<cfif (NOT len(trim(getISSOLD())))>
			<cfset thisError.field = "ISSOLD" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "ISSOLD is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif> <cfif (len(trim(getISSOLD())) AND NOT isNumeric(trim(getISSOLD())))>
			<cfset thisError.field = "ISSOLD" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ISSOLD is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setARTID" access="public" returntype="void" output="false">
		<cfargument name="ARTID" type="string" required="true" />
		<cfset variables.instance.ARTID = arguments.ARTID />
	</cffunction>
	<cffunction name="getARTID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ARTID />
	</cffunction>

	<cffunction name="setARTISTID" access="public" returntype="void" output="false">
		<cfargument name="ARTISTID" type="string" required="true" />
		<cfset variables.instance.ARTISTID = arguments.ARTISTID />
	</cffunction>
	<cffunction name="getARTISTID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ARTISTID />
	</cffunction>

	<cffunction name="setARTNAME" access="public" returntype="void" output="false">
		<cfargument name="ARTNAME" type="string" required="true" />
		<cfset variables.instance.ARTNAME = arguments.ARTNAME />
	</cffunction>
	<cffunction name="getARTNAME" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ARTNAME />
	</cffunction>

	<cffunction name="setDESCRIPTION" access="public" returntype="void" output="false">
		<cfargument name="DESCRIPTION" type="string" required="true" />
		<cfset variables.instance.DESCRIPTION = arguments.DESCRIPTION />
	</cffunction>
	<cffunction name="getDESCRIPTION" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DESCRIPTION />
	</cffunction>

	<cffunction name="setPRICE" access="public" returntype="void" output="false">
		<cfargument name="PRICE" type="string" required="true" />
		<cfset variables.instance.PRICE = arguments.PRICE />
	</cffunction>
	<cffunction name="getPRICE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PRICE />
	</cffunction>

	<cffunction name="setLARGEIMAGE" access="public" returntype="void" output="false">
		<cfargument name="LARGEIMAGE" type="string" required="true" />
		<cfset variables.instance.LARGEIMAGE = arguments.LARGEIMAGE />
	</cffunction>
	<cffunction name="getLARGEIMAGE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LARGEIMAGE />
	</cffunction>

	<cffunction name="setMEDIAID" access="public" returntype="void" output="false">
		<cfargument name="MEDIAID" type="string" required="true" />
		<cfset variables.instance.MEDIAID = arguments.MEDIAID />
	</cffunction>
	<cffunction name="getMEDIAID" access="public" returntype="string" output="false">
		<cfreturn variables.instance.MEDIAID />
	</cffunction>

	<cffunction name="setISSOLD" access="public" returntype="void" output="false">
		<cfargument name="ISSOLD" type="string" required="true" />
		<cfset variables.instance.ISSOLD = arguments.ISSOLD />
	</cffunction>
	<cffunction name="getISSOLD" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ISSOLD />
	</cffunction>


	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>