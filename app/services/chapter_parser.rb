class ChapterParser
  # Expanded patterns to match various chapter formats
  CHAPTER_PATTERNS = [
    /^CHAPTER\s+([IVXLCDM]+)\b/i,        # CHAPTER IV
    /^CHAPTER\s+(\d+)\b/i,               # CHAPTER 1
    /^Chapter\s+([A-Z]{2,})\b/i,         # Chapter Two
    /^([IVXLCDM]+)\.?\s*[-–—]\s*/i,      # IV. - or IV — 
    /^(\d+)\.?\s*[-–—]\s*/i,             # 1. - or 1 —
    /^[IVXLCDM]+$/i,                     # Standalone IV
    /^\d+$/                              # Standalone 1
  ]

  EXCLUDE_PATTERNS = [
    /illustration/i,
    /\[.*\]/,
    /table of contents/i
  ]

  def initialize(book, text)
    @book = book
    @text = text
  end

  def parse
    lines = @text.gsub(/\r\n?/, "\n").split(/\n/)
    
    chapters = []
    current_chapter = { title: "Prelude", content: [] }
    
    lines.each do |line|
      if should_exclude?(line)
        current_chapter[:content] << line
      elsif chapter_title = detect_chapter_title(line)
        chapters << current_chapter if current_chapter[:content].any?
        current_chapter = { 
          title: normalize_title(chapter_title),
          content: []
        }
      else
        current_chapter[:content] << line
      end
    end

    chapters << current_chapter if current_chapter[:content].any?
    
    chapters.each_with_index do |chapter, index|
      @book.chapters.create!(
        title: chapter[:title],
        content: chapter[:content].join("\n").strip,
        position: index + 1
      )
    end
  end

  private

  def should_exclude?(line)
    EXCLUDE_PATTERNS.any? { |pattern| line.match?(pattern) }
  end

  def detect_chapter_title(line)
    return nil if should_exclude?(line)
    
    CHAPTER_PATTERNS.each do |pattern|
      match = line.match(pattern)
      return match[1] if match && match[1]
      return line.strip if match  # For standalone numerals
    end
    nil
  end

  def normalize_title(title)
    # Convert Roman numerals to words if needed
    if title.match?(/^[IVXLCDM]+$/i)
      roman_to_word(title.upcase)
    elsif title.match?(/^\d+$/)
      "Chapter #{number_to_word(title.to_i)}"
    else
      title.strip.gsub(/^CHAPTER\s+/i, 'Chapter ')
    end
  end

  def roman_to_word(roman)
    # Simple conversion for common numerals
    conversions = {
      'I' => 'One', 'II' => 'Two', 'III' => 'Three', 'IV' => 'Four',
      'V' => 'Five', 'VI' => 'Six', 'VII' => 'Seven', 'VIII' => 'Eight',
      'IX' => 'Nine', 'X' => 'Ten', 'XI' => 'Eleven', 'XII' => 'Twelve'
    }
    conversions[roman] || "Chapter #{roman}"
  end

  def number_to_word(number)
    %w[Zero One Two Three Four Five Six Seven Eight Nine Ten Eleven Twelve][number] || number.to_s
  end
end