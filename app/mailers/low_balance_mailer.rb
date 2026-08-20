class LowBalanceMailer < ApplicationMailer
  default from: "Momak ERP <chat@momakgroup.co.ke>"

  def notify(emails, account)
    @account = account

    mail(
      to: emails,
      subject: "⚠️ Low Account Balance - #{@account.name}"
    )
  end
end