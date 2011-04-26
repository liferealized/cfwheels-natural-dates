<cfcomponent output="false" mixin="controller,model">

	<cffunction name="init" access="public" output="false">
		<cfscript>
			this.version = "1.0,1.1,1.1.1,1.1.2,1.1.3";	
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="dateRangeSelectTag" access="public" output="false" returntype="string">
		<cfargument name="selected" type="string" required="false" default="" />
		<cfargument name="singleDaysList" type="string" required="false" default="" />
		<cfargument name="lastDaysList" type="string" required="false" default="" />
		<cfargument name="monthsFromCurrent" type="numeric" required="false" default="0" />
		<cfargument name="yearsFromCurrent" type="numeric" required="false" default="0" />
		<cfargument name="customValues" type="string" required="false" default="" />
		<cfscript>
			var loc = {};
			arguments.options = [];
			arguments.customValues = ListToArray(arguments.customValues);
			
			for (loc.i = 1; loc.i lte ListLen(arguments.singleDaysList); loc.i++)
			{
				loc.array = [ "#ListGetAt(arguments.singleDaysList, loc.i)#", humanizeDateRange(ListGetAt(arguments.singleDaysList, loc.i)) ];
				ArrayAppend(arguments.options, loc.array);
			}
			
			for (loc.i = 1; loc.i lte ListLen(arguments.lastDaysList); loc.i++)
			{
				loc.array = [ "last-#ListGetAt(arguments.lastDaysList, loc.i)#-days", humanizeDateRange("last-#ListGetAt(arguments.lastDaysList, loc.i)#-days") ];
				ArrayAppend(arguments.options, loc.array);
			}
			
			for (loc.i = 0; loc.i lt arguments.monthsFromCurrent; loc.i++)
			{
				loc.nowDate = DateAdd("m", -loc.i, Now());
				loc.date = DateFormat(CreateDate(Year(loc.nowDate), Month(loc.nowDate), 1), "yyyy-mm");
				loc.array = [loc.date, humanizeDateRange(loc.date) ];
				ArrayAppend(arguments.options, loc.array);
			}
			
			for (loc.i = 0; loc.i lt arguments.yearsFromCurrent; loc.i++)
			{
				loc.string = loc.i & "-years-ago";
				if (loc.i == 0)
					loc.string = "this-year";
				else if (loc.i == 1)
					loc.string = "last-year";
				loc.array = [ loc.string, humanizeDateRange(loc.string) ];
				ArrayAppend(arguments.options, loc.array);
			}
			
			for (loc.i = 1; loc.i lte ArrayLen(arguments.customValues); loc.i++)
			{
				loc.array = [ arguments.customValues[loc.i], humanizeDateRange(arguments.customValues[loc.i]) ];
				ArrayAppend(arguments.options, loc.array);
			}
			
			StructDelete(arguments, "singleDaysList");
			StructDelete(arguments, "lastDaysList");
			StructDelete(arguments, "monthsFromCurrent");
			StructDelete(arguments, "yearsFromCurrent");
			StructDelete(arguments, "customValues");
		</cfscript>
		<cfreturn selectTag(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="humanizeDateRange" access="public" output="false" returntype="string">
		<cfargument name="range" type="string" required="true" />
		<cfscript>
			var returnValue = capitalize(Replace(arguments.range, "-", " ", "all"));
			if (IsDate(arguments.range))
				returnValue = DateFormat(arguments.range, "mmmm yyyy");
		</cfscript>
		<cfreturn returnValue />
	</cffunction>
	
	<cffunction name="parseDateString" access="public" returntype="any">
		<cfargument name="string" type="string" required="true" hint="today, yesterday, x-days-ago, last-x-days, previous-x-days, yyyy-mm, this-month, last-month, x-months-ago, this-week, last-week, x-weeks-ago" />
		<cfscript>
			var loc = {};
			
			// find and keep any numbers in our string
			loc.matches = REMatch("([0-9]+)", arguments.string);
			// parse out the numbers to create a string that we compare easily
			loc.string = arguments.string;
			for (loc.i = 1; loc.i lte ArrayLen(loc.matches); loc.i++)
				loc.string = ReplaceNoCase(loc.string, loc.matches[loc.i], "x", "one");
			
			switch (loc.string)
			{
				//today
				case "today":
				{
					return xDaysAgo(days=0);
				}
				
				// yesterday
				case "yesterday":
				{
					return xDaysAgo(days=1);
				}
				
				// x-days-ago
				case "x-days-ago":
				{
					return xDaysAgo(days=loc.matches[1]);
				}
				
				// last-x-days
				case "last-x-days":
				{
					loc.start = xDaysAgo(days=loc.matches[1] - 1); // we need a minus 1 because we are including today
					loc.end = xDaysAgo(days=0);
					return "#ListFirst(loc.start)#,#ListLast(loc.end)#";
				}
				
				// last-x-months
				case "last-x-months":
				{
					loc.start = xMonthsAgo(months=loc.matches[1] - 1);
					loc.end = xMonthsAgo(months=0);
					return "#ListFirst(loc.start)#,#ListLast(loc.end)#";
				}
				
				// previous-x-days
				case "previous-x-days":
				{
					loc.start = xDaysAgo(days=loc.matches[1]);
					loc.end = xDaysAgo(days=1);
					return "#ListFirst(loc.start)#,#ListLast(loc.end)#";
				}
				
				// last-x-months
				case "previous-x-months":
				{
					loc.start = xMonthsAgo(months=loc.matches[1]);
					loc.end = xMonthsAgo(months=1);
					return "#ListFirst(loc.start)#,#ListLast(loc.end)#";
				}
				
				// x-x
				case "x-x":
				{
					loc.start = startDateWithoutTime(loc.matches[1], loc.matches[2], 1);
					loc.end = DateAdd("s", -1, DateAdd("d", DaysInMonth(loc.start), loc.start));
					return "#loc.start#,#loc.end#";
				}
				
				// x-x-x
				case "x-x-x":
				{
					loc.start = startDateWithoutTime(loc.matches[1], loc.matches[2], loc.matches[3]);
					loc.end = DateAdd("s", -1, DateAdd("d", 1, loc.start));
					return "#loc.start#,#loc.end#";
				}
				
				// x-x-x,x-x-x
				case "x-x-x,x-x-x":
				{
					loc.start = startDateWithoutTime(loc.matches[1], loc.matches[2], loc.matches[3]);
					loc.end = CreateDateTime(loc.matches[4], loc.matches[5], loc.matches[6], 23, 59, 59);
					return "#loc.start#,#loc.end#";
				}
				
				// this-month
				case "this-month":
				{
					loc.start = CreateDate(Year(Now()), Month(Now()), 1);
					loc.end = DateAdd("s", -1, DateAdd("d", Day(Now()), loc.start));
					return "#loc.start#,#loc.end#";
				}
				
				// last-month
				case "last-month":
				{
					return xMonthsAgo(months=1);
				}
				
				// x-months-ago
				case "x-months-ago":
				{
					return xMonthsAgo(months=loc.matches[1]);
				}
				
				// this-week
				case "this-week":
				{
					loc.dayOffset = -DayOfWeek(Now()) + 1;
					loc.start = DateAdd('d', loc.dayOffset, startDateWithoutTime());
					loc.end = DateAdd("s", -1, DateAdd("d", Abs(loc.dayOffset) + 1, loc.start));
					return "#loc.start#,#loc.end#";
				}
				
				// last-week
				case "last-week":
				{
					return xWeeksAgo(weeks=1);
				}
				
				// x-weeks-ago
				case "x-weeks-ago":
				{
					return xWeeksAgo(weeks=loc.matches[1]);
				}
				
				// this-year
				case "this-year":
				{
					loc.start = CreateDate(Year(Now()), 1, 1);
					loc.end = DateAdd("s", -1, CreateDate(Year(Now()), Month(Now()), Day(Now()) + 1));
					return "#loc.start#,#loc.end#";
				}
				
				// last-year
				case "last-year":
				{
					return xYearsAgo(years=1);
				}
				
				// x-years-ago
				case "x-years-ago":
				{
					return xYearsAgo(years=loc.matches[1]);
				}
				
				default:
				{
					return arguments.string;
				}
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="startDateWithoutTime" access="public" output="false" returntype="date">
		<cfargument name="year" type="numeric" required="false" default="#Year(Now())#" />
		<cfargument name="month" type="numeric" required="false" default="#Month(Now())#" />
		<cfargument name="day" type="numeric" required="false" default="#Day(Now())#" />
		<cfreturn CreateDate(arguments.year, arguments.month, arguments.day) />
	</cffunction>
	
	<cffunction name="xDaysAgo" access="public" output="false" returntype="date">
		<cfargument name="days" type="numeric" required="true" />
		<cfset var loc = {} />
		<cfset loc.start = DateAdd("d", -arguments.days, startDateWithoutTime()) />
		<cfset loc.end = CreateDateTime(Year(loc.start), Month(loc.start), Day(loc.start), 23, 59, 59)  />
		<cfreturn "#loc.start#,#loc.end#" />
	</cffunction>
	
	<cffunction name="xWeeksAgo" access="public" output="false" returntype="string">
		<cfargument name="weeks" type="numeric" required="true" />
		<cfset var loc = {} />
		<cfset loc.dayOffset = -DayOfWeek(DateAdd("ww", -(arguments.weeks), Now())) + 1 />
		<cfset loc.start = DateAdd('d', loc.dayOffset, DateAdd("ww", -(arguments.weeks), startDateWithoutTime())) />
		<cfset loc.end =  DateAdd("s", -1, DateAdd("d", 7, loc.start)) />
		<cfreturn "#loc.start#,#loc.end#" />
	</cffunction>
	
	<cffunction name="xMonthsAgo" access="public" output="false" returntype="string">
		<cfargument name="months" type="numeric" required="true" />
		<cfset var loc = {} />
		<cfset loc.start = CreateDate(Year(DateAdd("m", -(arguments.months), Now())), Month(DateAdd("m", -(arguments.months), Now())), 1) />
		<cfset loc.end = DateAdd("s", -1, DateAdd("d", DaysInMonth(DateAdd("m", -(arguments.months), Now())), loc.start)) />
		<cfreturn "#loc.start#,#loc.end#" />
	</cffunction>
	
	<cffunction name="xYearsAgo" access="public" output="false" returntype="string">
		<cfargument name="years" type="numeric" required="true" />
		<cfset var loc = {} />
		<cfset loc.start = CreateDate(Year(DateAdd("yyyy", -(arguments.years), Now())), 1, 1) />
		<cfset loc.end = CreateDateTime(Year(DateAdd("yyyy", -(arguments.years), Now())), 12, 31, 23, 59, 59) />
		<cfreturn "#loc.start#,#loc.end#" />
	</cffunction>
	
</cfcomponent>