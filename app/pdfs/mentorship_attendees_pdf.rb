# app/pdfs/mentorship_attendees_pdf.rb

class MentorshipAttendeesPdf < Prawn::Document
  def initialize(mentorship)
    super(top_margin: 40)

    @mentorship = mentorship

    header_section
    attendees_table
  end

  private

  def header_section
    text "MENTORSHIP ATTENDEES REPORT",
         size: 18,
         style: :bold,
         align: :center

    move_down 20

    text "Mentorship: #{@mentorship.name}"
    text "Location: #{@mentorship.location}"
    text "Date: #{@mentorship.date}"
    text "Time: #{@mentorship.time}"
    text "Planned Visitors: #{@mentorship.planned_visitors}"
    text "Registered: #{@mentorship.mattendances.count}"

    move_down 20
  end

 def attendees_table
  table_data = [
    ["#", "Name", "Phone", "Location", "Registered On", "Signature"]
  ]

  @mentorship.mattendances.order(:created_at).each_with_index do |a, index|
    table_data << [
      index + 1,
      a.name,
      a.phone,
      a.location,
      a.created_at.strftime("%d-%m-%Y"),
      ""
    ]
  end

  table(
    table_data,
    header: true,
    width: bounds.width,
    cell_style: { size: 9 }
  ) do
    row(0).font_style = :bold
    row(0).background_color = "EEEEEE"

    columns(5).width = 100 # Signature column
    columns(5).align = :center

    cells.padding = 5
  end
end
end