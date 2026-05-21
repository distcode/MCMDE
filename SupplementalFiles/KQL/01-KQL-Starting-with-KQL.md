# KQL - Starting with KQL

This guide shows you how to use KQL elements to create basic queries.

Content

+ [Fundamentals](#fundamentals)
+ [Query Statements - Operators - Functions](#query-statements---operators---functions)
+ [Basic statements](#basic-statements)
  + [Operators limit/take, top](#operators-limittake-top)
  + [Operator sort by/order by](#operator-sort-byorder-by)
  + [Statement let](#statement-let)
  + [Operator project](#operator-project)
  + [Operator distinct](#operator-distinct)
  + [Operator search](#operator-search)
  + [Operator where](#operator-where)
  + [Operator extend](#operator-extend)
  + [Operator summarize](#operator-summarize)
  + [Operator render](#operator-render)

## Fundamentals

KQL is case-sensitive in general. Names of tables, variables, operators, etc. must be used with correct cases. For ignoring case-sensitivity of a search text use special operators. In the section of _Comparison operators_ you will find some examples.

## Query Statements - Operators - Functions

A KQL query can consist of different elements: user query statements, operators and functions. A query must have **tabular expression statement**, which generates one or more tabular results. These results are passed to operators via the pipe sign (|). After the pipe sign you will use table operators to filter, sort or edit the result. It's possible to have multiple pipe sign therefore the result could be created in several steps. This is called  data-flow model.

The request of a KQL query is always read-only and stated in plain text.

It is possible to use multiple lines for your query for a better reading. After a variable initialization or before a pipe sign change the line. A blank line indicates the end of a query statement. For executing a query select it or set the cursor anywhere in the query before you click the 'Go' button.

Following you will find basic elements of a query.

## Basic statements

### Operators limit/take, top

The operator `limit` is used to reduce the amount of records in the result. The result is not ordered therefore you could get different results for multiple executions of the following example:

```csl
VMComputer
| limit 5
```

The operator `take` is just an alias for `limit`:

```csl
VMComputer
| take 5
```

The operator `top by` will order the result before it is reduced. The next example shows you the last 3 records of the table `DeviceInfo`, because it is sorted in descending order by the column 'TimeGenerated':

```csl
VMComputer
| top 3 by TimeGenerated
```

To sort the table in the opposite direction use the parameter `asc`:

```csl
VMComputer
| top 3 by TimeGenerated asc
```

### Operator sort by/order by

To sort a list use the operator `sort by` or the alias of it `order by`. The result is automatically sorted in descending order. Use the parameter `asc` for ascending order (parameter `desc` is also supported):

```csl
VMComputer
| sort by DeviceName

VMComputer
| sort by DeviceName asc 
```

Also use multiple columns are supported in KQL:

```csl
VMComputer
| sort by DeviceName, PublicIP 

VMComputer
| sort by DeviceName asc, PublicIP desc 

VMComputer
| sort by DeviceName asc, PublicIP asc 
```

### Statement let

The statement `let` creates a variable. This variable could store a scalar value, an array (bag) or a table. The initialization of a variable must be finished by an semi-colon `(;)` and the variable must be used immediately in the following query. Avoid blank lines between the let statement and the query which uses the variable. Multiple variables for a query are allowed but each has to be created by it's own `let` statement.

```csl
let lmt = 3;
VMComputer 
| limit lmt

let myArray = dynamic(["value1","value2","value3"]);
print myArray

let myTable =
    DeviceInfo
    | limit 10;
myTable
```

### Operator project

By default all columns of a table are shown in the result of a query. To define which column should appear in the result use `project`.

```csl
VMComputer
| project DeviceName,DeviceType,PublicIP
```

`project-away` removes one or more columns:

```csl
VMComputer
| project TimeGenerated,BootTime
// This query shows all columns of the table DeviceInfo excep TimeGenerated and BootTime.
```

`project-keep` only keeps supported columns. In opposite to `project`, this operator allows wildcards.

```csl
VMComputer
| project-keep Computer,D*,Cpu*
// This query shows you the columns Computer, all columns with a name starting with d and all columns with a name staring with CPU.
// Keep in mind the case sensitivity of column names! 
```

`project-rename` offers you to rename columns.

```csl
VMComputer
| project Time = TimeGenerated, Hostname = Computer
```

`project-reorder` would let you reorder the columns without removing a column.

```csl
VMComputer
| project-reorder AzureSize,Cpus
// This query would put the columns AzureSize and Cpus as the first columns of the result.
```

### Operator distinct

This operator produces a table with distinct (unique/unambiguous) combination of the provided columns.

> [!NOTE]
> `distinct` defines the columns in the result as `project` would do it.

Example:

```csl
VMConnection
| distinct Computer,SourceIp
```

### Operator search

The `search` operator provides a multi-table/multi-column search experience.

Syntax: `[TabularSource |] search [kind=CaseSensitivity] [in (TableSources)] SearchPredicate`

Examples:

```csl
search vm092
// This query searches in all available tables for vm092

search in (Heartbeat, VMComputer, SecurityAlert) vm092
// This query searches in the tables Heartbeat, VMComputer and SecurityAlert for vm092.
```

To get a more precise result use the `where` operator. [See this section.](#operator-where)

### Operator where

The operator `where` filters your result. To get only records with the device name 'client1' use the following code:

```csl
Update
| where Computer == "JBOX00"
```

Available comparison operators:

| Name | Example | Notes |
| --- | --- | --- |
| == | `DeviceName == 'Client1'` | case sensitive equal |
| =~ | `DeviceName =~ 'client1'` | case in-sensitive equal |
| != | `OSType != 'Windows'` | case sensitive not equal |
| !~ | `OSType !~ 'windows'` | case in-sensitive not equal |
| >, >= | `Quantitiy > 0` | greater, greater or equal |
| <, <= | `Quantitiy <= 100` | less, less or equal |
| `startswith` | `DeviceName startswith 'srv'` | ~ `'srv*'` in SQL |
| `endswith` | `Device endswith '123'` | ~ `'*123'` |
| `contains` | `DeviceName contains 'vm'` | ~ `'\*vm\*'` |
| `startswith_cs` | `DeviceName startswith_cs 'srv'` | same as above but case sensitive |
| `endswith_cs` | `Device endswith_cs '123'` | same as above but case sensitive |
| `contains_cs` | `DeviceName contains_cs 'vm'` | same as above but case sensitive |
| `in` | `DeviceName in ('VM1', 'VM2')` | DeviceName must be 'VM1' or 'VM2' |
| `!in` | `DeviceName !in ('VM1','VM2')` | DeviceName must not be 'VM1' or 'VM2' |
| `in~` | `DeviceName in~ ('VM1', 'VM2')` | DeviceName must be 'VM1' or 'VM2', case in-sensitive |
| `!in~` | `DeviceName !in~ ('VM1', 'VM2')` | DeviceName must not be 'VM1' or 'VM2', case in-sensitive |
| `has` | `ProcessCommandLine has 'No'` | Search for text in records with multiple terms. |

The operator `has`should be preferred over `contains`as it is faster. But `has` finds only entire terms delimited by non-alphanumeric characters. `contains`also finds partial terms (e.g., `contains` finds "win" in "windows", `has` does not).

To work with multiple conditions use the operators `and` or `or`.

```csl
Update
| where Computer == "JBOX00" and Classification == "Security Updates"

Update
| where Computer == "JBOX00"
| where Classification == "Security Updates"
// The second query brings the same result as the first one.

Update
| where Computer == "JBOX00" or UpdateState == "Needed"
```

Each table has a field/column in which the record set creating time is stored. This column is named _TimeGenerated_ or _Timestamp_. To use these fields with the `where` operator, see the following examples:

```csl
Update
| where TimeGenerated >= ago(3h)
// The result dataset is not older than 3 hours.

Update
| where Timestamp > ago(30m) and Timestamp < ago(15m)
// The result dataset is not older than 30 minutes but older than 15 minutes.

Update
| where startofday(Timestamp) == startofday(now())
// The result dataset consists of data written today.
```

### Operator extend

The `extend` operator creates a calculated column and append it to the result set.

The following example converts the amount of physical Memory (MB) into GB:

```csl
VMComputer
| extend MemoryGB = PhysicalMemoryMB / 1024
| project PhysicalMemoryMB, MemoryGB
```

It is also possible to append multiple columns. Both examples lead to the same result:

```csl
VMComputer
| extend MemoryGB = PhysicalMemoryMB / 1024
| extend MemoryKB = PhysicalMemoryMB * 1024
| project PhysicalMemoryMB, MemoryGB, MemoryKB

VMComputer
| extend MemoryGB = PhysicalMemoryMB / 1024,
         MemoryKB = PhysicalMemoryMB * 1024
| project PhysicalMemoryMB, MemoryGB, MemoryKB
```

>**Hint:** With KQL, if you divide an integer by an integer, your result will be an integer (!). To get a value of double you have to convert at least one term of the calculation into a double:
>
>```cls
>VMComputer
>| extend MemoryGB = todouble(PhysicalMemoryMB) / 1024
>| project PhysicalMemoryMB, MemoryGB
>
>// or:
>
>VMComputer
>| extend MemoryGB = PhysicalMemoryMB / 1024.0
>| project PhysicalMemoryMB, MemoryGB
>```

The operator `project` could also be used for creating additional columns, but instead of appending the new column, `project` replaces all columns in the result set with the calculated. See the difference in the next example:

```csl
VMComputer
| extend MemoryGB = PhysicalMemoryMB / 1024

VMComputer
| project MemoryGB = PhysicalMemoryMB / 1024
```

### Operator summarize

This operator allows you to group your result and to use aggregate functions. `summarize` without an additional function would produce the same result as `distinct`.

```csl
AppEvents
| distinct ClientCountryOrRegion,ClientBrowser

AppEvents
| summarize by ClientCountryOrRegion,ClientBrowser
```

To use aggregate functions use the following syntax:

```csl
T | summarize [NewColumnName =] aggFunction() by Column1, Column2, Columnx
```

The next example creates a list of all stored countries and counts the records of each:

```csl
AppEvents
| summarize count() by ClientCountryOrRegion
```

To name the new calculated column:

```csl
AppEvents
| summarize Qty = count() by ClientCountryOrRegion
```

Basic aggregate functions:

| Name | Syntax | Note |
| --- | --- | --- |
| sum() | `summarize OverallSize = sum(FileSize) by DeviceName` | Calculates the sum of FileSize per DeviceName. |
| avg() | `summarize AverageSize = avg(FileSize) by DeviceName` | Calculates the average of FileSize per DeviceName. |
| min() | `summarize MinimumSize = min(FileSize) by DeviceName` | Returns the minimum value of FileSize per DeviceName. |
| max() | `summarize MaximumSize = max(FileSize) by DeviceName` | Returns the maximum value of FileSize per DeviceName. |

### Operator render

The operator `render` creates charts instead of tables/lists. It must be used with a parameter like `piechart`, `areachart`, `timechart`. Each parameter requires specific columns with the correct datatype. For more information see the [documentation](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/renderoperator?pivots=azuremonitor "operator render").

Examples:

```csl
AppEvents
| summarize Qty = count() by ClientCountryOrRegion
| render piechart
```

```csl
AppEvents
| where ClientStateOrProvince != '' and TimeGenerated >= ago(7d)
| summarize Qty = count() by bin(TimeGenerated, 4h), ClientStateOrProvince
| project TimeGenerated, Qty, ClientStateOrProvince
| render timechart 
```

![Time chart](images/timechart.png)
