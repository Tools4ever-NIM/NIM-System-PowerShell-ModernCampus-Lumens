#
# Workday.ps1 - Workday Web Services API (SOAP)
#


$Log_MaskableKeys = @(
    # Put a comma-separated list of attribute names here, whose value should be masked before 
    'Password',
    "apikey"
)

# System functions
#
function Idm-SystemInfo {
    param (
        # Operations
        [switch] $Connection,
        [switch] $TestConnection,
        [switch] $Configuration,
        # Parameters
        [string] $ConnectionParams
    )

    Log info "-Connection=$Connection -TestConnection=$TestConnection -Configuration=$Configuration -ConnectionParams='$ConnectionParams'"

    if ($Connection) {
        @(
            @{
                name = 'tenantid'
                type = 'textbox'
                label = 'Hostname'
                description = 'Hostname for Web Services'
                value = ''
            }
            @{
                name = 'apikey'
                type = 'textbox'
                label = 'API Key'
                label_indent = $true
                description = 'API Key'
                value = ''
            }
            @{
                name = 'pagesize'
                type = 'textbox'
                label = 'Page Size'
                label_indent = $true
                description = 'Number of records per page'
                value = '250'
            }
            @{
                name = 'use_proxy'
                type = 'checkbox'
                label = 'Use Proxy'
                description = 'Use Proxy server for requets'
                value = $false                  # Default value of checkbox item
            }
            @{
                name = 'proxy_address'
                type = 'textbox'
                label = 'Proxy Address'
                description = 'Address of the proxy server'
                value = 'http://localhost:8888'
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'use_proxy_credentials'
                type = 'checkbox'
                label = 'Use Proxy'
                description = 'Use Proxy server for requets'
                value = $false
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'proxy_username'
                type = 'textbox'
                label = 'Proxy Username'
                label_indent = $true
                description = 'Username account'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'proxy_password'
                type = 'textbox'
                password = $true
                label = 'Proxy Password'
                label_indent = $true
                description = 'User account password'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'nr_of_sessions'
                type = 'textbox'
                label = 'Max. number of simultaneous sessions'
                description = ''
                value = 1
            }
            @{
                name = 'sessions_idle_timeout'
                type = 'textbox'
                label = 'Session cleanup idle time (minutes)'
                description = ''
                value = 1
            }
        )
    }

    if ($TestConnection) {
        
    }

    if ($Configuration) {
        @()
    }

    Log info "Done"
}

function Idm-OnUnload {
}

#
# Object CRUD functions
#
$Properties = @{
    Instructor = @(
        @{ name = 'InstructorID';                              options = @('default','key')                      }
        @{ name = 'AltSystemInstructorID';                              options = @('default')                      }
        @{ name = 'CreateDate';                              options = @('default')                      }
        @{ name = 'CreateUser';                              options = @('default')                      }
        @{ name = 'ModifyDate';                              options = @('default')                      }
        @{ name = 'ModifyUser';                              options = @('default')                      }
        @{ name = 'LastTransferDate';                              options = @('default')                      }
        @{ name = 'Status';                              options = @('default')                      }
        @{ name = 'FirstName';                              options = @('default')                      }
        @{ name = 'MiddleInitial';                              options = @('default')                      }
        @{ name = 'LastName';                              options = @('default')                      }
        @{ name = 'Address1';                              options = @('default')                      }
        @{ name = 'Address2';                              options = @('default')                      }
        @{ name = 'City';                              options = @('default')                      }
        @{ name = 'StateProvince';                              options = @('default')                      }
        @{ name = 'PostalCode';                              options = @('default')                      }
        @{ name = 'ZipPlus4';                              options = @('default')                      }
        @{ name = 'IntlCountryID';                              options = @('default')                      }
        @{ name = 'EMail';                              options = @('default')                      }
        @{ name = 'Phone1';                              options = @('default')                      }
        @{ name = 'Phone1Ext';                              options = @('default')                      }
        @{ name = 'Phone1TypeID';                              options = @('default')                      }
        @{ name = 'Phone2';                              options = @('default')                      }
        @{ name = 'Phone2Ext';                              options = @('default')                      }
        @{ name = 'Phone2TypeID';                              options = @('default')                      }
        @{ name = 'Phone3';                              options = @('default')                      }
        @{ name = 'Phone3Ext';                              options = @('default')                      }
        @{ name = 'Phone3TypeID';                              options = @('default')                      }
        @{ name = 'Phone4';                              options = @('default')                      }
        @{ name = 'Phone4Ext';                              options = @('default')                      }
        @{ name = 'Phone4TypeID';                              options = @('default')                      }
        @{ name = 'InternalComments';                              options = @('default')                      }
        @{ name = 'Birthdate';                              options = @('default')                      }
        @{ name = 'Gender';                              options = @('default')                      }
        @{ name = 'EducationalLevelID';                              options = @('default')                      }
        @{ name = 'JobTitleID';                              options = @('default')                      }
        @{ name = 'CompanyTypeID';                              options = @('default')                      }
        @{ name = 'EmployerName';                              options = @('default')                      }
        @{ name = 'customer_instructor_id';                              options = @('default')                      }
        @{ name = 'GraphicFileName';                              options = @('default')                      }
        @{ name = 'PublicContactID';                              options = @('default')                      }
        @{ name = 'AllowInstructorToRecordAttendance';                              options = @('default')                      }
        @{ name = 'DaysAfterClassEndsGradesCanBeEntered';                              options = @('default')                      }
        @{ name = 'AllowInstructorToEnterGrades';                              options = @('default')                      }
        @{ name = 'AllowEMailToStudents';                              options = @('default')                      }
        @{ name = 'LoginData';                              options = @('default')                      }
        @{ name = 'CustomData';                              options = @('default')                      }
        @{ name = 'InstructorBios';                              options = @('default')                      }
        @{ name = 'InstructorEarnings_Approved';                              options = @('default')                      }
        @{ name = 'InstructorPayments';                              options = @('default')                      }
    )
    Learner = @(
         @{ name = 'LearnerID';                              options = @('default','key')                      }
        @{ name = 'AltSystemLearnerID';                              options = @('default')                      }
        @{ name = 'CreateDate';                              options = @('default')                      }
        @{ name = 'CreateUser';                              options = @('default')                      }
        @{ name = 'ModifyDate';                              options = @('default')                      }
        @{ name = 'ModifyUser';                              options = @('default')                      }
        @{ name = 'LastTransferDate';                              options = @('default')                      }
        @{ name = 'Status';                              options = @('default')                      }
        @{ name = 'FirstName';                              options = @('default')                      }
        @{ name = 'MiddleInitial';                              options = @('default')                      }
        @{ name = 'LastName';                              options = @('default')                      }
        @{ name = 'Address1';                              options = @('default')                      }
        @{ name = 'Address2';                              options = @('default')                      }
        @{ name = 'City';                              options = @('default')                      }
        @{ name = 'StateProvince';                              options = @('default')                      }
        @{ name = 'PostalCode';                              options = @('default')                      }
        @{ name = 'ZipPlus4';                              options = @('default')                      }
        @{ name = 'IntlCountryID';                              options = @('default')                      }
        @{ name = 'Country';                              options = @('default')                      }
        @{ name = 'EMail';                              options = @('default')                      }
        @{ name = 'Phone1';                              options = @('default')                      }
        @{ name = 'Phone1Ext';                              options = @('default')                      }
        @{ name = 'Phone1TypeID';                              options = @('default')                      }
        @{ name = 'Phone2';                              options = @('default')                      }
        @{ name = 'Phone2Ext';                              options = @('default')                      }
        @{ name = 'Phone2TypeID';                              options = @('default')                      }
        @{ name = 'Phone3';                              options = @('default')                      }
        @{ name = 'Phone3Ext';                              options = @('default')                      }
        @{ name = 'Phone3TypeID';                              options = @('default')                      }
        @{ name = 'Phone4';                              options = @('default')                      }
        @{ name = 'Phone4Ext';                              options = @('default')                      }
        @{ name = 'Phone4TypeID';                              options = @('default')                      }
        @{ name = 'MembershipID';                              options = @('default')                      }
        @{ name = 'PreviousMembershipID';                              options = @('default')                      }
        @{ name = 'EligibleForFeeWaive';                              options = @('default')                      }
        @{ name = 'InternalComments';                              options = @('default')                      }
        @{ name = 'CustomerMailingsFlag';                              options = @('default')                      }
        @{ name = 'LastRegistrationFeeDate';                              options = @('default')                      }
        @{ name = 'CompanyID';                              options = @('default')                      }
        @{ name = 'CreditAmount';                              options = @('default')                      }
        @{ name = 'OriginalCreditAmount';                              options = @('default')                      }
        @{ name = 'CustomerLearnerID';                              options = @('default')                      }
        @{ name = 'Birthdate';                              options = @('default')                      }
        @{ name = 'Gender';                              options = @('default')                      }
        @{ name = 'ReferralTypeID';                              options = @('default')                      }
        @{ name = 'EducationalLevelID';                              options = @('default')                      }
        @{ name = 'JobTitleID';                              options = @('default')                      }
        @{ name = 'CompanyTypeID';                              options = @('default')                      }
        @{ name = 'CountyID';                              options = @('default')                      }
        @{ name = 'County';                              options = @('default')                      }
        @{ name = 'OptCountryID';                              options = @('default')                      }
        @{ name = 'EmployerName';                              options = @('default')                      }
        @{ name = 'CustomerEmailPref';                              options = @('default')                      }
        @{ name = 'IsEmployee';                              options = @('default')                      }
        @{ name = 'IsSenior';                              options = @('default')                      }
        @{ name = 'IsResident';                              options = @('default')                      }
        @{ name = 'IsAlumni';                              options = @('default')                      }
        @{ name = 'IsAcademicallyDisadvantaged';                              options = @('default')                      }
        @{ name = 'IsEconomicallyDisadvantaged';                              options = @('default')                      }
        @{ name = 'IsDisabled';                              options = @('default')                      }
        @{ name = 'IsLimitedEnglish';                              options = @('default')                      }
        @{ name = 'IsDisplacedHomemaker';                              options = @('default')                      }
        @{ name = 'IsSingleParent';                              options = @('default')                      }
        @{ name = 'EthnicityID';                              options = @('default')                      }
        @{ name = 'InDirectory';                              options = @('default')                      }
        @{ name = 'IsTransfer';                              options = @('default')                      }
        @{ name = 'TransferFICECode';                              options = @('default')                      }
        @{ name = 'TuitionWaiverID';                              options = @('default')                      }
        @{ name = 'RemoteCampusID';                              options = @('default')                      }
        @{ name = 'MajorTypeID';                              options = @('default')                      }
        @{ name = 'MajorCIPCode';                              options = @('default')                      }
        @{ name = 'CETuitionStatusID';                              options = @('default')                      }
        @{ name = 'IsUSCitizen';                              options = @('default')                      }
        @{ name = 'OH_IAISwitch';                              options = @('default')                      }
        @{ name = 'OH_AWE_Race';                              options = @('default')                      }
        @{ name = 'CA_MIS_Ethnicity_Learner';                              options = @('default')                      }
        @{ name = 'CA_MIS_EducationalLevel';                              options = @('default')                      }
        @{ name = 'CA_MIS_EducationalGoal';                              options = @('default')                      }
        @{ name = 'CA_MIS_JTPAStatus';                              options = @('default')                      }
        @{ name = 'CA_MIS_Coopworkexpedutype';                              options = @('default')                      }
        @{ name = 'CA_MIS_TechPrepStatus';                              options = @('default')                      }
        @{ name = 'CA_MIS_LastEnrolledTerm';                              options = @('default')                      }
        @{ name = 'CA_MIS_SingleParentStatus';                              options = @('default')                      }
        @{ name = 'CA_MIS_DisplacedhomemakerStatus';                              options = @('default')                      }
        @{ name = 'CA_MIS_EconomicallyDisadvantagedStatus';                              options = @('default')                      }
        @{ name = 'IsESLStudent';                              options = @('default')                      }
        @{ name = 'IsAcademicCreditStudent';                              options = @('default')                      }
        @{ name = 'AcademicCreditCitizenshipID';                              options = @('default')                      }
        @{ name = 'IDVerificationTypeID';                              options = @('default')                      }
        @{ name = 'VisaExpirationDate';                              options = @('default')                      }
        @{ name = 'NativeAncestryTypeID';                              options = @('default')                      }
        @{ name = 'AlbertaEducationID';                              options = @('default')                      }
        @{ name = 'Edmonton_ResidencyStatusTypeID';                              options = @('default')                      }
        @{ name = 'EdmontonPublicID';                              options = @('default')                      }
        @{ name = 'EdmontonCreateSISProfile';                              options = @('default')                      }
        @{ name = 'LoginData';                              options = @('default')                      }
        @{ name = 'CustomData';                              options = @('default')                      }
        @{ name = 'MembershipData';                              options = @('default')                      }
        @{ name = 'LearnerCreditData';                              options = @('default')                      }
    )
}



function Idm-LearnersRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "Learner"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {

        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $properties = $function_params.properties

        if ($properties.length -eq 0) {
            $properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        $properties = @($key) + @($properties | Where-Object { $_ -ne $key })
        
        try {                 
                $i = 0;
                
                $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru

                while($true)
                {
                    Log info ("Retrieving records {0} - {1}" -f $i, ($i+$system_params.pagesize))
                    $xmlRequest = '<?xml version="1.0" encoding="ISO-8859-1"?>
                                    <Wrapper>
                                    <Request StartRow="{0}" EndRow="{1}">
                                    <Criteria>
                                        <AltSystemLearnerID><![CDATA[]]></AltSystemLearnerID>
                                        <LearnerID><![CDATA[]]></LearnerID>
                                        <LastName><![CDATA[]]></LastName>
                                        <FirstName><![CDATA[]]></FirstName>
                                        <Email><![CDATA[]]></Email>
                                        <CreateDateBegin><![CDATA[]]></CreateDateBegin>
                                        <CreateDateEnd><![CDATA[]]></CreateDateEnd>
                                        <ModifyDateBegin><![CDATA[]]></ModifyDateBegin>
                                        <ModifyDateEnd><![CDATA[]]></ModifyDateEnd>
                                        <LastTransferDateBegin><![CDATA[]]></LastTransferDateBegin>
                                        <LastTransferDateEnd><![CDATA[]]></LastTransferDateEnd>
                                        <NewOrModifiedSinceLastTransfer><![CDATA[Yes]]></NewOrModifiedSinceLastTransfer>
                                        <Status><![CDATA[]]></Status>
                                        <CompanyID><![CDATA[]]></CompanyID>
                                        <Address><![CDATA[]]></Address>
                                        <City><![CDATA[]]></City>
                                        <Birthdate><![CDATA[]]></Birthdate>
                                        <Phone><![CDATA[]]></Phone>
                                        <FindDuplicates></FindDuplicates>
                                    </Criteria>
                                    </Request>
                                    </Wrapper>' -f $i, ($i+$system_params.pagesize)
                    
                    $response = $client.GetLearnerDetails($system_params.apikey, $xmlRequest)

                    $hash_table = [ordered]@{}

                    foreach ($column_name in $properties) {
                        $hash_table[$column_name] = ""
                    }
                    
                    $pageCount = ([xml]$response).Wrapper.ResponseData.LearnerDetail.Learners.count
                    
                    #Seems to be a bug in the API, provides more records than requested. Logging this
                    if($pageCount -gt $system_params.pagesize) { 
                        Log warn "Result count larger than page size"
                     }
                    $i = $i + $pageCount + 1

                    foreach($item in ([xml]$response).Wrapper.ResponseData.LearnerDetail.Learners ) {
                            
                        $obj = New-Object -TypeName PSObject -Property $hash_table

                        foreach ($column_name in $properties) {
                            if($item.$column_name.GetType().Name -ne 'XmlElement')
                            {
                                $obj.$column_name = $item.$column_name
                            }
                        }

                        $obj
                    }
                    
                    if($pageCount -lt $system_params.pagesize) { break }
                }
            }
            catch {
                Log error "Failed: $_"
                Write-Error $_
            }
    }

    Log info "Done"
}


function Idm-InstructorsRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "Instructor"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {

        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $properties = $function_params.properties

        if ($properties.length -eq 0) {
            $properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        $properties = @($key) + @($properties | Where-Object { $_ -ne $key })
        
        try {                 
                $i = 0;
                $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru
                
                while($true)
                {
                    Log info ("Retrieving records {0} - {1}" -f $i, ($i+$system_params.pagesize))
                    $xmlRequest = '<?xml version="1.0" encoding="ISO-8859-1"?>
                                    <Wrapper>
                                    <Request StartRow="{0}" EndRow="{1}">
                                        <Criteria>
                                        <AltSystemInstructorID><![CDATA[]]></AltSystemInstructorID>
                                        <InstructorID><![CDATA[]]></InstructorID>
                                        <LastName><![CDATA[]]></LastName>
                                        <FirstName><![CDATA[]]></FirstName>
                                        <Email><![CDATA[]]></Email>
                                        <CreateDateBegin><![CDATA[]]></CreateDateBegin>
                                        <CreateDateEnd><![CDATA[]]></CreateDateEnd>
                                        <ModifyDateBegin><![CDATA[]]></ModifyDateBegin>
                                        <ModifyDateEnd><![CDATA[]]></ModifyDateEnd>
                                        <LastTransferDateBegin><![CDATA[]]></LastTransferDateBegin>
                                        <LastTransferDateEnd><![CDATA[]]></LastTransferDateEnd>
                                        <NewOrModifiedSinceLastTransfer><![CDATA[Yes]]></NewOrModifiedSinceLastTransfer>
                                        <Status><![CDATA[]]></Status>
                                        </Criteria>
                                    </Request>
                                    </Wrapper>' -f $i, ($i+$system_params.pagesize)
                    $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru
                    $response = $client.GetInstructorDetails($system_params.apikey, $xmlRequest)

                    $hash_table = [ordered]@{}

                    foreach ($column_name in $properties) {
                        $hash_table[$column_name] = ""
                    }
                    
                    $pageCount = ([xml]$response).Wrapper.ResponseData.InstructorDetail.Instructors.count
                    
                    #Seems to be a bug in the API, provides more records than requested. Logging this
                    if($pageCount -gt $system_params.pagesize) { 
                        Log warn "Result count larger than page size"
                     }
                    $i = $i + $pageCount + 1
                    
                    foreach($item in ([xml]$response).Wrapper.ResponseData.InstructorDetail.Instructors ) {
                        $obj = New-Object -TypeName PSObject -Property $hash_table

                        foreach ($column_name in $properties) {
                            if($item.$column_name.GetType().Name -ne 'XmlElement')
                            {
                                $obj.$column_name = $item.$column_name
                            }
                        }

                        $obj
                    }
                    
                    if($pageCount -lt $system_params.pagesize) { break }
                }
            }
            catch {
                Log error "Failed: $_"
                Write-Error $_
            }
    }

    Log info "Done"
}

function Get-ClassMetaData {
    param (
        [string] $SystemParams,
        [string] $Class
    )
    
    @(
        @{
            name = 'properties'
            type = 'grid'
            label = 'Properties'
            description = 'Selected properties'
            table = @{
                rows = @( $Global:Properties.$Class | ForEach-Object {
                    @{
                        name = $_.name
                        usage_hint = @( @(
                            foreach ($opt in $_.options) {
                                if ($opt -notin @('default', 'idm', 'key')) { continue }

                                if ($opt -eq 'idm') {
                                    $opt.Toupper()
                                }
                                else {
                                    $opt.Substring(0,1).Toupper() + $opt.Substring(1)
                                }
                            }
                        ) | Sort-Object) -join ' | '
                    }
                })
                settings_grid = @{
                    selection = 'multiple'
                    key_column = 'name'
                    checkbox = $true
                    filter = $true
                    columns = @(
                        @{
                            name = 'name'
                            display_name = 'Name'
                        }
                        @{
                            name = 'usage_hint'
                            display_name = 'Usage hint'
                        }
                    )
                }
            }
            value = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }
    )
}
function New-ModernCampusLumensConnection {
    param (
        [hashtable] $SystemParams,
        [hashtable] $FunctionParams

    )
    
    $wsdlUrl = "https://{0}/ws/apiOpn.wsdl" -f $SystemParams.tenantId
    Log info ("Reading SOAP WSDL [{0}]" -f $wsdlUrl)

    try {
        $proxy = New-WebServiceProxy -Uri $wsdlUrl -UseDefaultCredential
        <#if($system_params.use_proxy)
        {
            $splat["Proxy"] = $system_params.proxy_address

            if($system_params.use_proxy_credentials)
            {
                $splat["proxyCredential"] = New-Object System.Management.Automation.PSCredential ($system_params.proxy_username, (ConvertTo-SecureString $system_params.proxy_password -AsPlainText -Force) )
            }
        }#>
	}
	<#catch [System.Net.WebException] {
       
        try {
            $reader = New-Object System.IO.StreamReader -ArgumentList $_.Exception.Response.GetResponseStream()
            $response = $reader.ReadToEnd()
            $reader.Close()

            $result = ([xml]$response).Envelope.Body.InnerXml

            # Log the first Workday Exception
            if ($result.InnerXml.StartsWith('<SOAP-ENV:Fault ')) {
                $message = "Error : $($o.Xml.Fault.faultcode): $($o.Xml.Fault.faultstring)"
                Log error $message
                Write-Error $message
            }
        }
        catch {}
        
        $message = "Error : $($_)"
        Log error $message
        Write-Error $_
	}#>
    catch {
        $message = "Error : $($_)"
        Log error $message
        Write-Error $_
    }
    finally {
        $proxy
    }
}
