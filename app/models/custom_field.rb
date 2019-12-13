# frozen_string_literal: true

class CustomField < ApplicationRecord
  FIELD_MODELS = {
#    'Organization' => I18n.t('activerecord.models.organization.one'),
#    'User' => I18n.t('activerecord.models.user.one'),
#    'Department' => I18n.t('activerecord.models.department.one'),
#    'Agreement' => I18n.t('activerecord.models.agreement.one'),
#    'AgreementKind' => I18n.t('activerecord.models.agreement_kind.one'),
#    'Article' => I18n.t('activerecord.models.article.one'),
#    'OrganizationKind' =>  I18n.t('activerecord.models.organization_kind.one'),
#    'Attachment' => I18n.t('activerecord.models.attachment.one'),
#    'AttachmentLink' => I18n.t('activerecord.models.attachment_link.one'),
#    'TagKind' => I18n.t('activerecord.models.tag_kind.one'),
#    'Tag' => I18n.t('activerecord.models.tag.one'),
#    'TagMember' => I18n.t('activerecord.models.tag_member.one'),
#    'Incident' => I18n.t('activerecord.models.incident.one'),
#    'Host' => I18n.t('activerecord.models.host.one'),
#    'LinkKind' => I18n.t('activerecord.models.link_kind.one'),
#    'Link' => I18n.t('activerecord.models.link.one'),
#    'RecordTemplate' => I18n.t('activerecord.models.record_template.one'),
#    'Versions' => I18n.t('labels.version.versions'),
#    'Reports' => I18n.t('labels.reports'),
#    'Charts' => I18n.t('navigations.charts'),
#    'Dashboards' => I18n.t('navigations.dashboards'),
#    'ScanOption' => I18n.t('activerecord.models.scan_option.one'),
#    'ScanJob' => I18n.t('activerecord.models.scan_job.one'),
#    'ScanResult' => I18n.t('activerecord.models.scan_result.one'),
#    'HostService' => I18n.t('activerecord.models.host_service.one'),
#    'Schedule' => I18n.t('activerecord.models.schedule.one'),
#    'ScanJobLog' => I18n.t('activerecord.models.scan_job_log.one'),
#    'ScanJobsHost' => I18n.t('activerecord.models.scan_jobs_host.one'),
#    'Feed' => I18n.t('activerecord.models.feed.one'),
#    'InvestigationKind' => I18n.t('activerecord.models.investigation_kind.one'),
    'Investigation' => I18n.t('activerecord.models.investigation.one'),
    'Indicator' => I18n.t('activerecord.models.indicator.one'),
    'Vulnerability' => I18n.t('activerecord.models.vulnerability.one'),
    'VulnerabilityBulletin' => I18n.t('activerecord.models.vulnerability_bulletin.one')
  }.freeze

  enum data_type: {
    string: 'string',
    text: 'text',
    datetime: 'datetime',
    number: 'number',
    boolean: 'boolean'
  }

  def self.field_models
    FIELD_MODELS
  end

  validates :name, length: { minimum: 1, maximum: 100 }
  validates :name, uniqueness: { scope: :field_model }
  validates :field_model, inclusion: { in: CustomField.field_models.keys }
  validates :data_type, inclusion: { in: CustomField.data_types.keys }

end
