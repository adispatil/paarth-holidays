class LeadsModel {
  final bool status;
  final List<Lead> pendingLeads;
  final List<Lead> activeLeads;
  final List<Lead> closedLeads;

  LeadsModel({
    required this.status,
    required this.pendingLeads,
    required this.activeLeads,
    required this.closedLeads,
  });

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    return LeadsModel(
      status: json['status'] ?? false,
      pendingLeads: (json['pending_leads'] as List?)
              ?.map((e) => Lead.fromJson(e))
              .toList() ??
          [],
      activeLeads: (json['active_leads'] as List?)
              ?.map((e) => Lead.fromJson(e))
              .toList() ??
          [],
      closedLeads: (json['closed_leads'] as List?)
              ?.map((e) => Lead.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Lead {
  final String id;
  final String leadName;
  final String leadContact;
  final String leadSector;
  final String leadByType;
  final String status;
  final String createdDate;
  final String createdBy;
  final String modifiedDate;
  final String modifiedBy;
  final String stateName;

  Lead({
    required this.id,
    required this.leadName,
    required this.leadContact,
    required this.leadSector,
    required this.leadByType,
    required this.status,
    required this.createdDate,
    required this.createdBy,
    required this.modifiedDate,
    required this.modifiedBy,
    required this.stateName
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id']?.toString() ?? '',
      leadName: json['lead_name']?.toString() ?? '',
      leadContact: json['lead_contact']?.toString() ?? '',
      leadSector: json['lead_sector']?.toString() ?? '',
      leadByType: json['lead_by_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdDate: json['created_date']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      modifiedDate: json['modified_date']?.toString() ?? '',
      modifiedBy: json['modified_by']?.toString() ?? '',
      stateName: json['stateName']?.toString() ?? '',
    );
  }
} 