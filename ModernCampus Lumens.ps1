#
# Lumens.ps1 - Lumens Web Services API (SOAP)
#
$Global:DataAge = 60 # Minutes before data expires and is pulled fresh.
$Global:Learners    = @{LastRefresh = Get-Date; XML = [Collections.Generic.List[Object]]::new();}
$Global:Instructors = @{LastRefresh = Get-Date; XML = [Collections.Generic.List[Object]]::new();}
$Global:ClassDetails = @{LastRefresh = Get-Date; XML = [Collections.Generic.List[Object]]::new();}

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
$Global:Properties = @{
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
    LearnerCustomData = @(
        @{ name = 'LearnerID';                              options = @('default')                      }
        @{ name = 'FieldName';                              options = @('default')                      }
        @{ name = 'FieldValue';                             options = @('default')                      }
    )
    LearnerMembershipData = @(
        @{ name = 'LearnerID';                              options = @('default')                      }
    )
    LearnerLearnerCreditData = @(
        @{ name = 'LearnerID';                              options = @('default')                      }
    )
    InstructorCustomData = @(
        @{ name = 'InstructorID';                           options = @('default')                      }
        @{ name = 'FieldName';                              options = @('default')                      }
        @{ name = 'FieldValue';                             options = @('default')                      }
    )
    InstructorLoginData = @(
        @{ name = 'InstructorID';                                options = @('default')                      }    
        @{ name = 'UserID';                                options = @('default')                      }
        @{ name = 'LastLoggedInDate';                                options = @('default')                      }
        @{ name = 'PasswordHint';                                options = @('default')                      }
        @{ name = 'SecretQuestionID';                                options = @('default')                      }
        @{ name = 'str_alt_sys_user_id';                                options = @('default')                      }
        @{ name = 'UserName';                                options = @('default') }
    )
    LearnerLoginData = @(
        @{ name = 'LearnerID';                                options = @('default')                      }    
        @{ name = 'UserID';                                options = @('default')                      }
        @{ name = 'LastLoggedInDate';                                options = @('default')                      }
        @{ name = 'PasswordHint';                                options = @('default')                      }
        @{ name = 'SecretQuestionID';                                options = @('default')                      }
        @{ name = 'str_alt_sys_user_id';                                options = @('default')                      }
        @{ name = 'UserName';                                options = @('default') }
    )
    ClassDetail = @(
        @{ name = 'ClassID';                          options = @('default','key')                      }
        @{ name = 'CreateDate';                              options = @('default')                      }
        @{ name = 'CreateUser';                              options = @('default')                      }
        @{ name = 'ModifyDate';                              options = @('default')                      }
        @{ name = 'ModifyUser';                              options = @('default')                      }
        @{ name = 'CourseNumber';                              options = @('default')                      }
        @{ name = 'CourseID';                              options = @('default')                      }
        @{ name = 'AltSystemCourseID';                              options = @('default')                      }
        @{ name = 'STATUS';                              options = @('default')                      }
        @{ name = 'NAME';                              options = @('default')                      }
        @{ name = 'Description';                              options = @('default')                      }
        @{ name = 'TermID';                              options = @('default')                      }
        @{ name = 'TermCode';                              options = @('default')                      }
        @{ name = 'StartDate';                              options = @('default')                      }
        @{ name = 'EndDate';                              options = @('default')                      }
        @{ name = 'DisplayStartDate';                              options = @('default')                      }
        @{ name = 'DisplayEndDate';                              options = @('default')                      }
        @{ name = 'StaffRegistrationStartDate';                              options = @('default')                      }
        @{ name = 'PublicRegistrationStartDate';                              options = @('default')                      }
        @{ name = 'PublicRegistrationEndDate';                              options = @('default')                      }
        @{ name = 'NumberOfSessions';                              options = @('default')                      }
        @{ name = 'NumberOfWeeks';                              options = @('default')                      }
        @{ name = 'PublicRegistration';                              options = @('default')                      }
        @{ name = 'ContactPhone';                              options = @('default')                      }
        @{ name = 'RegistrationFeeRequired';                              options = @('default')                      }
        @{ name = 'ClassCost';                              options = @('default')                      }
        @{ name = 'MaterialsFeesCost';                              options = @('default')                      }
        @{ name = 'LabFeesCost';                              options = @('default')                      }
        @{ name = 'InsuranceFeesCost';                              options = @('default')                      }
        @{ name = 'BuildingFeesCost';                              options = @('default')                      }
        @{ name = 'BookFeesCost';                              options = @('default')                      }
        @{ name = 'ProgramFeesCost';                              options = @('default')                      }
        @{ name = 'CollectMaterialsCostInAdvance';                              options = @('default')                      }
        @{ name = 'AccountingCodeForMaterialsCost';                              options = @('default')                      }
        @{ name = 'MarketingCosts';                              options = @('default')                      }
        @{ name = 'OrganazationMaterialCosts';                              options = @('default')                      }
        @{ name = 'OtherCosts';                              options = @('default')                      }
        @{ name = 'GoNumber';                              options = @('default')                      }
        @{ name = 'TotalSeats';                              options = @('default')                      }
        @{ name = 'RemainingSeats';                              options = @('default')                      }
        @{ name = 'RequiresReleaseForm';                              options = @('default')                      }
        @{ name = 'ReleaseFormID';                              options = @('default')                      }
        @{ name = 'RefundPolicyID';                              options = @('default')                      }
        @{ name = 'AllowQuantityPurchase';                              options = @('default')                      }
        @{ name = 'LessonReleaseID';                              options = @('default')                      }
        @{ name = 'ContactHours';                              options = @('default')                      }
        @{ name = 'IsContractTraining';                              options = @('default')                      }
        @{ name = 'CatalogID';                              options = @('default')                      }
        @{ name = 'CompanyID';                              options = @('default')                      }
        @{ name = 'CompanyUserID';                              options = @('default')                      }
        @{ name = 'CEUs';                              options = @('default')                      }
        @{ name = 'UsesDeferredPaymentOption';                              options = @('default')                      }
        @{ name = 'LectureHours';                              options = @('default')                      }
        @{ name = 'LabHours';                              options = @('default')                      }
        @{ name = 'AWEReferenceNumber';                              options = @('default')                      }
        @{ name = 'NewCourseDistrict';                              options = @('default')                      }
        @{ name = 'ClassSubmittedReimbursement';                              options = @('default')                      }
        @{ name = 'ClassFiscalYears';                              options = @('default')                      }
        @{ name = 'ClassApprenticeship';                              options = @('default')                      }
        @{ name = 'ReportEnrollmentStudents';                              options = @('default')                      }
        @{ name = 'ClassCustomizedCompany';                              options = @('default')                      }
        @{ name = 'ConsultativeContact';                              options = @('default')                      }
        @{ name = 'T2202aEligible';                              options = @('default')                      }
        @{ name = 'TuitionFeePSTExempt';                              options = @('default')                      }
        @{ name = 'LabFeePSTExempt';                              options = @('default')                      }
        @{ name = 'InsuranceFeePSTExempt';                              options = @('default')                      }
        @{ name = 'BuildingFeePSTExempt';                              options = @('default')                      }
        @{ name = 'BookFeePSTExempt';                              options = @('default')                      }
        @{ name = 'ProgramFeePSTExempt';                              options = @('default')                      }
        @{ name = 'MaterialFeePSTExempt';                              options = @('default')                      }
        @{ name = 'TuitionFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'LabFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'InsuranceFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'BuildingFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'BookFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'ProgramFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'MaterialFeeGSTExempt';                              options = @('default')                      }
        @{ name = 'TuitionFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'LabFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'InsuranceFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'BuildingFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'BookFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'ProgramFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'MaterialFeeHSTExempt';                              options = @('default')                      }
        @{ name = 'int_edsis_id';                              options = @('default')                      }
        @{ name = 'SCEnterpriseZone';                              options = @('default')                      }
        @{ name = 'SCApprenticeshipClass';                              options = @('default')                      }
        @{ name = 'ScheduleType';                              options = @('default')                      }
        @{ name = 'DeliveryType';                              options = @('default')                      }
        @{ name = 'OpenEndTimePeriodQuantity';                              options = @('default')                      }
        @{ name = 'SubcategoryID';                              options = @('default')                      }
        @{ name = 'CategoryID';                              options = @('default')                      }
        @{ name = 'DisplayToPublic';                              options = @('default')                      }
        @{ name = 'LMSProvider';                              options = @('default')                      }
        @{ name = 'BadgingProvider';                              options = @('default')                      }
        @{ name = 'SSNRequiredToRegister';                              options = @('default')                      }
        @{ name = 'UseClassPrerequisites';                              options = @('default')                      }
    )
    ClassDetailCustomData = @(
        @{ name = 'ClassID';                                options = @('default')                      }
        @{ name = 'FieldName';                              options = @('default')                      }
        @{ name = 'FieldValue';                             options = @('default')                      }
    )
    ClassDetailLearner = @(
        @{ name = 'ClassID';                              options = @('default')                      }
        @{ name = 'LearnerID';                              options = @('default')                      }
        @{ name = 'RegistrationName';                              options = @('default')                      }
        @{ name = 'RegistrationDate';                              options = @('default')                      }
        @{ name = 'CancelDate';                              options = @('default')                      }
        @{ name = 'FirstName';                              options = @('default')                      }
        @{ name = 'MiddleInitial';                              options = @('default')                      }
        @{ name = 'LastName';                              options = @('default')                      }
        @{ name = 'Address1';                              options = @('default')                      }
        @{ name = 'Address2';                              options = @('default')                      }
        @{ name = 'City';                              options = @('default')                      }
        @{ name = 'StateProvince';                              options = @('default')                      }
        @{ name = 'PostalCode';                              options = @('default')                      }
        @{ name = 'ZipPlus4';                              options = @('default')                      }
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
        @{ name = 'InternalComments';                              options = @('default')                      }
        @{ name = 'CustomerLearnerID';                              options = @('default')                      }
        @{ name = 'Gender';                              options = @('default')                      }
    )
    ClassDetailInstructor = @(
        @{ name = 'ClassID';                              options = @('default')                      }
        @{ name = 'InstructorID';                              options = @('default')                      }
        @{ name = 'AltSystemInstructorID';                              options = @('default')                      }
        @{ name = 'InstructorBioID';                              options = @('default')                      }
        @{ name = 'AltSystemInstructorBioID';                              options = @('default')                      }
        @{ name = 'FirstName';                              options = @('default')                      }
        @{ name = 'LastName';                              options = @('default')                      }
        @{ name = 'RateType';                              options = @('default')                      }
        @{ name = 'PaymentRate';                              options = @('default')                      }
        @{ name = 'InstructorConfirmed';                              options = @('default')                      }
        @{ name = 'HoursToBePaid';                              options = @('default')                      }
        @{ name = 'AcctCodeForInstructorPay';                              options = @('default')                      }
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

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        
        # Get LearnerDetail records and iterate over them, returning the data to NIM.
        Get-LearnersXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in $Global:Learners.XML.Learners) {
                        
            $obj = New-Object -TypeName PSObject -Property $hash_table

            foreach ($column_name in $l_properties) {
                if($item.$column_name.GetType().Name -ne 'XmlElement')
                {
                    $obj.$column_name = $item.$column_name
                }
            }

            $obj
        }
    }

    Log info "Done"
}

function Idm-LearnerCustomDatasRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "LearnerCustomData"
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
        if($key) {
            $properties = @($key) + @($properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-LearnersXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:Learners.XML.Learners | Where-Object {$_.CustomData.HasChildNodes -eq 'true'})) {
            
            foreach($cd in $item.CustomData.FieldDetails) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.LearnerID = $item.LearnerID
                $obj.FieldName = $cd.FieldName
                $obj.FieldValue = $cd.FieldValue
                $obj
            }
        }
    }

    Log info "Done"
}

function Idm-LearnerLoginDatasRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "LearnerLoginData"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        if($key) {
            $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-LearnersXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:Learners.XML.Learners | Where-Object {$_.LoginData.HasChildNodes -eq 'true'})) {
            
            foreach($user in $item.LoginData.User) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.LearnerID = $item.LearnerID
                
                foreach ($column_name in $l_properties) {
                    if($user.$column_name -and $user.$column_name.GetType().Name -ne 'XmlElement')
                    {
                        $obj.$column_name = $user.$column_name
                    }
                }
                
                $obj
            }
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
        
        Get-InstructorsXML -SystemParams $SystemParams -FunctionParams $FunctionParams        
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $properties) {
            $hash_table[$column_name] = ""
        }
                
        foreach($item in $Global:Instructors.XML.Instructors ) {
            $obj = New-Object -TypeName PSObject -Property $hash_table

            foreach ($column_name in $properties) {
                if($item.$column_name.GetType().Name -ne 'XmlElement')
                {
                    $obj.$column_name = $item.$column_name
                }
            }

            $obj
        }
    }

    Log info "Done"
}

function Idm-InstructorLoginDatasRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "InstructorLoginData"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        if($key) {
            $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-InstructorsXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:Instructors.XML.Instructors | Where-Object {$_.LoginData.HasChildNodes -eq 'true'})) {
            
            foreach($user in [array]$item.LoginData.User) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.InstructorID = $item.InstructorID
                
                foreach ($column_name in $l_properties) {
                    if($user.$column_name -and $user.$column_name.GetType().Name -ne 'XmlElement')
                    {
                        $obj.$column_name = $user.$column_name
                    }
                }
                
                $obj
            }
        }
    }

    Log info "Done"
}

function Idm-InstructorCustomDatasRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "InstructorCustomData"
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
        if($key) {
            $properties = @($key) + @($properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-InstructorsXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:Instructors.XML.Instructors | Where-Object {$_.CustomData.HasChildNodes -eq 'true'})) {
            
            foreach($cd in $item.CustomData.FieldDetails) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.InstructorID = $item.InstructorID
                $obj.FieldName = $cd.FieldName
                $obj.FieldValue = $cd.FieldValue
                $obj
            }
        }
    }

    Log info "Done"
}

function Idm-ClassDetailsRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "ClassDetail"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {

        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        
        Get-ClassDetailsXML -SystemParams $SystemParams -FunctionParams $FunctionParams        
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in $Global:ClassDetails.XML ) {
            $obj = New-Object -TypeName PSObject -Property $hash_table

            foreach ($column_name in $l_properties) {
                if($item.$column_name.GetType().Name -ne 'XmlElement')
                {
                    $obj.$column_name = $item.$column_name
                }
            }
            $i += 1
            $obj
        }
        
    }

    Log info "Done"
}

function Idm-ClassDetailsLearnersRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "ClassDetailLearner"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        if($key) {
            $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-ClassDetailsXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:ClassDetails.XML | Where-Object {$_.RosterDetails.HasChildNodes -eq 'true'})) {
            
            foreach($i in [array]$item.RosterDetails.Learner) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.ClassID = $item.ClassID
                foreach ($column_name in ($l_properties | Where-Object {$_ -ne 'ClassID'})) {
                    if($i.$column_name -and $i.$column_name.GetType().Name -ne 'XmlElement')
                    {
                        $obj.$column_name = $i.$column_name
                    }

                }
                
                $obj
            }
        }
    }

    Log info "Done"
}

function Idm-ClassDetailsInstructorsRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "ClassDetailInstructor"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        if($key) {
            $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-ClassDetailsXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:ClassDetails.XML | Where-Object {$_.InstructorDetails.HasChildNodes -eq 'true'})) {
            
            foreach($i in [array]$item.InstructorDetails.Instructor) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.ClassID = $item.ClassID
                foreach ($column_name in ($l_properties | Where-Object {$_ -ne 'ClassID'})) {
                    if($i.$column_name -and $i.$column_name.GetType().Name -ne 'XmlElement')
                    {
                        $obj.$column_name = $i.$column_name
                    }
                    
                }
                
                $obj
            }
        }
    }

    Log info "Done"
}

function Idm-ClassDetailsCustomDatasRead {
    param (
        [switch] $GetMeta,
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $Class = "ClassDetailCustomData"
    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"

    if ($GetMeta) {
        Get-ClassMetaData -SystemParams $SystemParams -Class $Class
    }
    else {
        
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $l_properties = $function_params.properties

        if ($l_properties.length -eq 0) {
            $l_properties = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }

        # Assure key is the first column
        $key = ($Global:Properties.$Class | Where-Object { $_.options.Contains('key') }).name
        if($key) {
            $l_properties = @($key) + @($l_properties | Where-Object { $_ -ne $key })
        }
        
        # Get LearnerDetail records.  Will use cache data if available, or get the data if this is run before the idm-LearnersRead is run.
        Get-ClassDetailsXML -SystemParams $SystemParams -FunctionParams $FunctionParams
        
        $hash_table = [ordered]@{}
        foreach ($column_name in $l_properties) {
            $hash_table[$column_name] = ""
        }

        foreach($item in ($Global:ClassDetails.XML | Where-Object {$_.CustomData.HasChildNodes -eq 'true'})) {
            
            foreach($cd in $item.CustomData.field) {
                $obj = New-Object -TypeName PSObject -Property $hash_table
                $obj.ClassID = $item.ClassID
                $obj.FieldName = $cd.FieldName
                $obj.FieldValue = $cd.FieldValue
                
                $obj
            }
        }
    }

    Log info "Done"
}

##  Learner - Custom Data Create & Update
function Idm-LearnerCustomDatasSet {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $function_params = ConvertFrom-Json2 $FunctionParams
    $system_params   = ConvertFrom-Json2 $SystemParams

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @( 
                @{ name = 'LearnerID';         allowance = 'mandatory'  },
                @{ name = 'FieldName';allowance = 'mandatory'   },
                @{ name = 'FieldValue';     allowance = 'mandatory'  },
                @{ name = '*';              allowance = 'prohibited' }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $operation       = 'Update'
        $id_num          = $function_params.'LearnerID'
        $fieldName       = $function_params.'FieldName'
        $fieldValue      = $function_params.'FieldValue'

        # Create XML:
        $xmlBody = @'
<?xml version="1.0" encoding="ISO-8859-1"?>
<Wrapper>
    <Settings ForceDuplicateUsername="No" />
    <InputData>
        <Learner AddOrUpdate="{0}">
            <LearnerDetail>
                <LearnerID>{1}</LearnerID>
            </LearnerDetail>
            <CustomData>
                <FieldName>
                    <![CDATA[{2}]]>
                </FieldName>
                <FieldValue>
                    <![CDATA[{3}]]>
                </FieldValue>
            </CustomData>
        </Learner>
    </InputData>
</Wrapper> 
'@ -f $operation, $id_num, $fieldName, $fieldValue

        # Create API Connection
        $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru
        
        # Call API
        $response = $client.AddAndUpdateLearner($system_params.apikey, $xmlBody)
        #Write-Host $xmlBody
        Log info ("Response: {0}" -f ([xml]$response).Wrapper.ResponseData)
    }
    Log info ("Done - Result: {0}" -f ($response | ConvertTo-Json -Depth 4))
}

##  Learner - Custom Data Create & Update
function Idm-InstructorCustomDatasSet {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log info "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $function_params = ConvertFrom-Json2 $FunctionParams
    $system_params   = ConvertFrom-Json2 $SystemParams

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @( 
                @{ name = 'InstructorID';         allowance = 'mandatory'  },
                @{ name = 'FirstName';allowance = 'mandatory' }
                @{ name = 'LastName';allowance = 'mandatory' }
                @{ name = 'UserName';allowance = 'mandatory' }
                @{ name = 'FieldName';allowance = 'mandatory'   },
                @{ name = 'FieldValue';     allowance = 'mandatory'  },
                @{ name = '*';              allowance = 'prohibited' }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $operation       = 'Update'
        $id_num          = $function_params.'InstructorID'
        $alt_ID          = (New-Guid).toString() -replace '-.*'
        $firstName       = $function_params.'FirstName'
        $lastName        = $function_params.'LastName'
        $userName        = $function_params.'UserName'
        $fieldName       = $function_params.'FieldName'
        $fieldValue      = $function_params.'FieldValue'

        # Create XML:
        $xmlBody = @'
<?xml version="1.0" encoding="ISO-8859-1"?>
<Wrapper>
    <Settings ForceDuplicateUsername="No" />
    <InputData>
        <Instructor AddOrUpdate="{0}">
            <InstructorDetail>
                <AltSystemUserID><![CDATA[{1}]]></AltSystemUserID>
                <AltSystemInstructorID><![CDATA[{1}]]></AltSystemInstructorID>
                <InstructorID>{2}</InstructorID>
                <FirstName> <![CDATA[{3}]]></FirstName>
                <LastName><![CDATA[{4}]]></LastName>
                <UserName><![CDATA[{5}]]></UserName>
            </InstructorDetail>
            <CustomData>
                    <FieldName><![CDATA[{6}]]></FieldName>
                    <FieldValue><![CDATA[{7}]]></FieldValue>
            </CustomData>
        </Instructor>
    </InputData>
</Wrapper>
'@  -f  $operation,
        $alt_ID,
        $id_num,
        $firstName,
        $lastName,
        $userName,
        $fieldName,
        $fieldValue

        # Create API Connection
        $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru
        
        # Call API
        $response = $client.AddAndUpdateInstructor($system_params.apikey, $xmlBody)
        #Write-Host $xmlBody
        Log info ("Response: {0}" -f ([xml]$response).Wrapper.ResponseData)
    }
    Log info ("Done - Result: {0}" -f ($response | ConvertTo-Json -Depth 4))
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

        <#  2024-01-26 - T4e JA
            HACK - Adding a hack to adjust the target URL.  The Test Lumens environment
                expects calls to the v81 endpoints, but the WSDL is still returning
                the V80 endpoints.  This can be gotten around by changing the Url in the proxy.
            2024-07-01 - T4e JA - Removing, since Lumens upped to always be 81.
        #>
        #$proxy.Url = $proxy.Url -replace 'v81','v80'

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

function Get-LearnersXML {
    param(
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $system_params   = ConvertFrom-Json2 $SystemParams
    $function_params = ConvertFrom-Json2 $FunctionParams

    # Return cached XML data if available and within the refresh window - 5 minutes.
    if($Global:Learners.XML.count -gt 0 -AND $Global:Learners.LastRefresh -gt (Get-Date).AddMinutes(-$Global:DataAge))
    {
        return
    }

    # No current data or it is 'expired'.  Pull new data.
    try {
        # Reset Global List
        $Global:Learners.XML.Clear() | Out-Null
        $Global:Learners.XML.TrimExcess() | Out-Null
        
        # Set Starting Record:
        $i = 1;
        
        $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru

        do {
            Log info ("Retrieving records {0} - {1}" -f $i, ($i+$system_params.pagesize))
            $xmlRequest = '<?xml version="1.0" encoding="ISO-8859-1"?>
                            <Wrapper>
                            <Request StartRow="{0}" EndRow="{1}">
                            <Criteria>
                                <CreateDateBegin><![CDATA[2000-01-01]]></CreateDateBegin>
                                <CreateDateEnd><![CDATA[2078-01-01]]></CreateDateEnd>
                            </Criteria>
                            </Request>
                            </Wrapper>' -f $i, ($i+$system_params.pagesize)
            
            $response = $client.GetLearnerDetails($system_params.apikey, $xmlRequest)
            Log info ("Response: {0}" -f ([xml]$response).Wrapper.description)
            $pageCount = ([xml]$response).Wrapper.LearnerDetail.Learners.count
            
            # Set new Start Page
            $i += $pageCount
            
            # Add Learners to Global List.
            if($pageCount) {
                $Global:Learners.XML.AddRange([array](([xml]$response).Wrapper.LearnerDetail))
            }
        } while ($pageCount -ge $system_params.pagesize)

        # Data pulled.  Setting LastRefresh value.
        $Global:Learners.LastRefresh = (Get-Date)
        
        # No return needed as data stored in Global Variable.
    }
    catch {
        Log error "Failed: $_"
        Write-Error $_
    }
}

function Get-InstructorsXML {
    param(
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $system_params   = ConvertFrom-Json2 $SystemParams
    $function_params = ConvertFrom-Json2 $FunctionParams

    # Return cached XML data if available and within the refresh window - 5 minutes.
    if($Global:Instructors.XML.count -gt 0 -AND $Global:Instructors.LastRefresh -gt (Get-Date).AddMinutes(-$Global:DataAge))
    {
        return
    }

    # No current data or it is 'expired'.  Pull new data.
    try {
        # Reset Global List
        $Global:Instructors.XML.Clear() | Out-Null
        $Global:Instructors.XML.TrimExcess() | Out-Null
        
        # Set Starting Record:
        $i = 1;
        
        $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru

        do {
            Log info ("Retrieving records {0} - {1}" -f $i, ($i+$system_params.pagesize))
            <#
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
                                <Status><![CDATA[]]></Status>
                                </Criteria>
                            </Request>
                            </Wrapper>' -f $i, ($i+$system_params.pagesize)  # <NewOrModifiedSinceLastTransfer><![CDATA[Yes]]></NewOrModifiedSinceLastTransfer>
                        #>
            $xmlRequest = '<?xml version="1.0" encoding="ISO-8859-1"?>
                            <Wrapper>
                                <Request StartRow="{0}" EndRow="{1}">
                                    <Criteria>
                                        <CreateDateBegin><![CDATA[2000-01-01]]></CreateDateBegin>
                                        <CreateDateEnd><![CDATA[2078-01-01]]></CreateDateEnd>
                                    </Criteria>
                                </Request>
                            </Wrapper>' -f $i, ($i+$system_params.pagesize)  # <NewOrModifiedSinceLastTransfer><![CDATA[Yes]]></NewOrModifiedSinceLastTransfer>

            $response = $client.GetInstructorDetails($system_params.apikey, $xmlRequest)
            Log info ("Response: {0}" -f ([xml]$response).Wrapper.ResponseData.description)
            $pageCount = ([xml]$response).Wrapper.ResponseData.InstructorDetail.count
            
            # Set new Start Page
            $i += $pageCount
            
            # Add to Global List.
            if($pageCount) {
                $Global:Instructors.XML.AddRange([array](([xml]$response).Wrapper.ResponseData.InstructorDetail))
            }
            
        } while ($pageCount -ge $system_params.pagesize)

        # Data pulled.  Setting LastRefresh value.
        $Global:Instructors.LastRefresh = (Get-Date)
        
        # No return needed as data stored in Global Variable.
    }
    catch {
        Log error "Failed: $_"
        Write-Error $_
    }
}

function Get-ClassDetailsXML {
    param(
        [string] $SystemParams,
        [string] $FunctionParams
    )
    $system_params   = ConvertFrom-Json2 $SystemParams
    $function_params = ConvertFrom-Json2 $FunctionParams

    # Return cached XML data if available and within the refresh window - 5 minutes.
    if($Global:ClassDetails.XML.count -gt 0 -AND $Global:ClassDetails.LastRefresh -gt (Get-Date).AddMinutes(-$Global:DataAge))
    {
        return
    }

    # No current data or it is 'expired'.  Pull new data.
    try {
        # Reset Global List
        $Global:ClassDetails.XML.Clear() | Out-Null
        $Global:ClassDetails.XML.TrimExcess() | Out-Null
        
        # Set Starting Record:
        $i = 1;
        
        $client = New-ModernCampusLumensConnection -SystemParams $system_params -FunctionParams $function_params -PassThru

        do {
            Log info ("Retrieving records {0} - {1}" -f $i, ($i+$system_params.pagesize))
            $xmlRequest = '<?xml version="1.0" encoding="ISO-8859-1"?>
                            <Wrapper>
                                <Request StartRow="{0}" EndRow="{1}">
                                    <Criteria>
                                        <CreateDateBegin><![CDATA[2000-01-01]]></CreateDateBegin>
                                        <CreateDateEnd><![CDATA[2078-01-01]]></CreateDateEnd>
                                    </Criteria>
                                </Request>
                            </Wrapper>' -f $i, ($i+$system_params.pagesize)  # <NewOrModifiedSinceLastTransfer><![CDATA[Yes]]></NewOrModifiedSinceLastTransfer>
            $response = $client.GetClassDetails($system_params.apikey, $xmlRequest)
            Log info ("Response: {0}" -f ([xml]$response).Wrapper.description)
            $pageCount = ([xml]$response).Wrapper.ClassDetails.Classes.count
            
            # Set new Start Page
            $i += $pageCount
            
            # Add to Global List.
            if($pageCount) {
                $Global:ClassDetails.XML.AddRange([array](([xml]$response).Wrapper.ClassDetails.Classes))
            }
            
        } while ($pageCount -ge $system_params.pagesize)

        # Data pulled.  Setting LastRefresh value.
        $Global:ClassDetails.LastRefresh = (Get-Date)
        
        # No return needed as data stored in Global Variable.
    }
    catch {
        Log error "Failed: $_"
        Write-Error $_
    }
}

# (([xml]$response).Wrapper.ResponseData.ClassDetails | ? {$_.Classes.TotalSeats -ne $_.Classes.RemainingSeats})[10].classes.RosterDetails.Learner[0]