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

<cfoutput><:cfcomponent>
<:cfset this.name = "myORMApplication">
<:cfset this.ormenabled = "true">
<:cfset this.datasource = "#session.database#">
<!-- ORM Setting not suggeted for production use-->
<:cfset this.ormsettings = {autorebuild="true"}>
</:cfcomponent></cfoutput>
<cfsetting enablecfoutputonly="false" />