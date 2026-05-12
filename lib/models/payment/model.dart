class PaymentModel {
  final int id;
  final String client;
  final String photo;
  final String loan_officer;
  final String client_id;
  final String loan_id;
  final String client_code;
  final String total_repayment;
  final String amount_penalty;
  final String submitted_on;
  final String payment_type;
  final String status_pay;
  final String syncedate;
  final String synced;
  PaymentModel({
    required this.id,
    required this.client,
    required this.photo,
    required this.loan_officer,
    required this.client_id,
    required this.loan_id,
    required this.client_code,
    required this.total_repayment,
    required this.amount_penalty,
    required this.submitted_on,
    required this.payment_type,
    required this.status_pay,
    required this.syncedate,
    required this.synced,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      // id: json['id'] ?? 'N/A',
      id: int.tryParse(json['id'].toString()) ?? 0,
      client: json['client'] ?? 'N/A',
      photo: json['photo'] ?? 'N/A',
      loan_officer: json['loan_officer'] ?? 'N/A',
      client_id: json['client_id'] ?? 'N/A',
      loan_id: json['loan_id'] ?? 'N/A',
      client_code: json['client_code'] ?? 'N/A',
      total_repayment: json['total_repayment'] ?? 'N/A',
      amount_penalty: json['amount_penalty'] ?? 'N/A',
      submitted_on: json['submitted_on'] ?? 'N/A',
      payment_type: json['payment_type'] ?? 'N/A',
      status_pay: json['status_pay'] ?? 'N/A',
      syncedate: json['syncedate'] ?? 'N/A',
      // synced: json['synced'] ?? "0",
      synced: json['synced']?.toString() ?? '0',
    );
  }
}
