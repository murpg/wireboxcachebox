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

<cfparam name="ideeventinfo" >
<cflock scope="Application" timeout="10">
	<cfset application.appId = (isdefined("application.appId")?application.appId : 0) + 1>
</cflock>

<cfset application[#application.appId#] = ideeventinfo>
<cfset nextUrl = new Framework.Util().generateURL("ormCFCGenUI.cfm")>
<cfset nextUrl &= "?genId=" & #application.appId#>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide url="#nextUrl#" >
		<dialog width="800" height="700" dialogclosehandler="onORMClose.cfm" />
	</ide>
</response>
</cfoutput>
