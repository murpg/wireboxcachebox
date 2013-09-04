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

<cfoutput>
component output="false"
     {
	/* properties */
	<cfloop from="1" to="#arrayLen(settings.field)#" index="i">property name="#settings.field[i].name#" type="#settings.field[i].cftype#" <cfif NOT input.compat>setter="true" getter="true"</cfif>;#linebreak(1)##tab(1)#</cfloop>

	<cfif input.compat>
	var INSTANCE = {};
	<cfloop from="1" to="#arrayLen(settings.field)#" index="i">var INSTANCE.#settings.field[i].name# = "";
	</cfloop>
	</cfif>

	/* init */
	function init()
	{
		return this;
	}

	<cfif input.compat>
	 /*INFO:If This Application is to be run under ColdFusion 9 then the following getters and setters can be removed.
	 			If you delete the getters and setters you should enable use-implicit-getters option in serviceconfig.xml present in webroot/WEB-INF/flex */
				
	<cfloop from="1" to="#arrayLen(settings.field)#" index="i">/* #settings.field[i].name# accesor */
	function get#settings.field[i].name#()
	{
		return INSTANCE.#settings.field[i].name#;
	}
	function set#settings.field[i].name#(value) 
	{
		var INSTANCE.#settings.field[i].name# = ARGUMENTS.value;
	}
	<cfif i LT arrayLen(settings.field)>#linebreak(1)##tab(1)#</cfif></cfloop></cfif>

}
</cfoutput>
<cfsetting enablecfoutputonly="false" />
