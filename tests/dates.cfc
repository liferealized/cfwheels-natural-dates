<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_parseDateString_today">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("today") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()), Day(Now()))") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_yesterday">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("yesterday") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()), Day(DateAdd('d', -1, Now())))") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(DateAdd('d', -1, Now())), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_number_days_ago">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("3-days-ago") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()), Day(DateAdd('d', -3, Now())))") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(DateAdd('d', -3, Now())), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_last_number_days">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("last-3-days") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()), Day(DateAdd('d', -2, Now())))") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(DateAdd('d', 0, Now())), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_previous_number_days">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("previous-3-days") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()), Day(DateAdd('d', -3, Now())))") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(DateAdd('d', -1, Now())), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_year_month">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("2010-04") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(2010, 04, 01)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(2010, 04, 30, 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_year_month_day">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("2010-04-27") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(2010, 04, 27)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(2010, 04, 27, 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_year_month_day_year_month_day">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("last-month") />
		<cfset loc.span2 = loc.user.parseDateString("#DateFormat(ListFirst(loc.span), 'yyyy-mm-dd')#,#DateFormat(ListLast(loc.span), 'yyyy-mm-dd')#") />
		<cfset assert("loc.span eq loc.span2") />
	</cffunction>

	<cffunction name="test_parseDateString_this_month">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("this-month") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()), 1)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_last_month">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("last-month") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), Month(Now()) - 1, 1)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()) - 1, DaysInMonth(DateAdd('m', -1, Now())), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_number_months_ago">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("9-months-ago") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(DateAdd('m', -9, Now())), Month(DateAdd('m', -9, Now())), 1)") />
		<cfset assert("ListLast(loc.span) eq DateAdd('s', -1, DateAdd('d', DaysInMonth(DateAdd('m', -9, Now())), CreateDate(Year(DateAdd('m', -9, Now())), Month(DateAdd('m', -9, Now())), 1)))") />
	</cffunction>

	<cffunction name="test_parseDateString_this_week">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("this-week") />
		<cfset assert("ListFirst(loc.span) eq DateAdd('d', -DayOfWeek(Now()) + 1, CreateDate(Year(Now()), Month(Now()), Day(Now())))") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_last_week">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("last-week") />
		<cfset assert("ListFirst(loc.span) eq DateAdd('d', -DayOfWeek(DateAdd('ww', -1, CreateDate(Year(Now()), Month(Now()), Day(Now())))) + 1, DateAdd('ww', -1, CreateDate(Year(Now()), Month(Now()), Day(Now()))))") />
	</cffunction>

	<cffunction name="test_parseDateString_x_weeks_ago">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("7-weeks-ago") />
		<cfset assert("ListFirst(loc.span) eq DateAdd('d', -DayOfWeek(DateAdd('ww', -7, CreateDate(Year(Now()), Month(Now()), Day(Now())))) + 1, DateAdd('ww', -7, CreateDate(Year(Now()), Month(Now()), Day(Now()))))") />
	</cffunction>

	<cffunction name="test_parseDateString_this_year">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("this-year") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(Now()), 1, 1)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_last_year">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("last-year") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(DateAdd('yyyy', -1, Now())), 1, 1)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(DateAdd('yyyy', -1, Now())), 12, 31, 23, 59, 59)") />
	</cffunction>

	<cffunction name="test_parseDateString_number_years_ago">
		<cfset loc.user = model("user").findByKey(1) />
		<cfset loc.span = loc.user.parseDateString("3-years-ago") />
		<cfset assert("ListFirst(loc.span) eq CreateDate(Year(DateAdd('yyyy', -3, Now())), 1, 1)") />
		<cfset assert("ListLast(loc.span) eq CreateDateTime(Year(DateAdd('yyyy', -3, Now())), 12, 31, 23, 59, 59)") />
	</cffunction>

</cfcomponent>



