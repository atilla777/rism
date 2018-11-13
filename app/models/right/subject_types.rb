# frozen_string_literl: true
module Right::SubjectTypes
  SUBJECT_TYPES = {
    'Organization' => I18n.t('activerecord.models.organization.one'),
    'User' => I18n.t('activerecord.models.user.one'),
    'Department' => I18n.t('activerecord.models.department.one'),
    'Agreement' => I18n.t('activerecord.models.agreement.one'),
    'AgreementKind' => I18n.t('activerecord.models.agreement_kind.one'),
    'Article' => I18n.t('activerecord.models.article.one'),
    'OrganizationKind' =>  I18n.t('activerecord.models.organization_kind.one'),
    'Attachment' => I18n.t('activerecord.models.attachment.one'),
    'AttachmentLink' => I18n.t('activerecord.models.attachment_link.one'),
    'TagKind' => I18n.t('activerecord.models.tag_kind.one'),
    'Tag' => I18n.t('activerecord.models.tag.one'),
    'TagMember' => I18n.t('activerecord.models.tag_member.one'),
    'Incident' => I18n.t('activerecord.models.incident.one'),
    'Host' => I18n.t('activerecord.models.host.one'),
    'LinkKind' => I18n.t('activerecord.models.link_kind.one'),
    'Link' => I18n.t('activerecord.models.link.one'),
    'RecordTemplate' => I18n.t('activerecord.models.record_template.one'),
    'Versions' => I18n.t('labels.version.versions'),
    'Reports' => I18n.t('labels.reports'),
    'Charts' => I18n.t('navigations.charts'),
    'Dashboards' => I18n.t('navigations.dashboards'),
    'ScanOption' => I18n.t('activerecord.models.scan_option.one'),
    'ScanJob' => I18n.t('activerecord.models.scan_job.one'),
    'ScanResult' => I18n.t('activerecord.models.scan_result.one'),
    'HostService' => I18n.t('activerecord.models.host_service.one'),
    'Schedule' => I18n.t('activerecord.models.schedule.one'),
    'ScanJobLog' => I18n.t('activerecord.models.scan_job_log.one'),
    'ScanJobsHost' => I18n.t('activerecord.models.scan_jobs_host.one')
  }.freeze
end
