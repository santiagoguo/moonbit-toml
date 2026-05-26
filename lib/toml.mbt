pub enum TomlValue {
  Str(String)
  Int(Int)
  Float(Double)
  Bool(Bool)
}

pub impl Show for TomlValue with to_string(self : TomlValue) -> String {
  match self {
    TomlValue::Str(s) => s
    TomlValue::Int(i) => i.to_string()
    TomlValue::Float(f) => f.to_string()
    TomlValue::Bool(b) => b.to_string()
  }
}

struct ParseState {
  input : String
  pos : Int
}

fn ParseState::new(input : String) -> ParseState {
  { input, pos: 0 }
}

fn ParseState::is_eof(self : ParseState) -> Bool {
  self.pos >= self.input.length()
}

fn ParseState::current(self : ParseState) -> String {
  if self.is_eof() { "" } else { self.input[self.pos : self.pos + 1].to_string() }
}

fn ParseState::advance(self : ParseState) -> ParseState {
  if self.is_eof() { self } else { { input: self.input, pos: self.pos + 1 } }
}

fn ParseState::skip_ws(self : ParseState) -> ParseState {
  let mut s = self
  while s.current() == " " || s.current() == "\t" {
    s = s.advance()
  }
  s
}

pub fn parse_toml(input : String) -> Map[String, TomlValue] {
  let root : Map[String, TomlValue] = Map([])
  let mut s = ParseState::new(input)
  
  while !s.is_eof() {
    s = s.skip_ws()
    if s.is_eof() { break }
    
    let mut key = ""
    while !s.is_eof() {
      let c = s.current()
      if (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || (c >= "0" && c <= "9") || c == "_" || c == "-" {
        key = key + c
        s = s.advance()
      } else { break }
    }
    
    s = s.skip_ws()
    if s.current() == "=" { s = s.advance() }
    s = s.skip_ws()
    
    let val = if s.current() == "\"" {
      s = s.advance()
      let mut v = ""
      while s.current() != "\"" && !s.is_eof() {
        v = v + s.current()
        s = s.advance()
      }
      if s.current() == "\"" { s = s.advance() }
      TomlValue::Str(v)
    } else if (s.current() >= "0" && s.current() <= "9") || s.current() == "-" {
      let mut num_str = ""
      while ((s.current() >= "0" && s.current() <= "9") || s.current() == "." || s.current() == "_" || s.current() == "-") && !s.is_eof() {
        num_str = num_str + s.current()
        s = s.advance()
      }
      // Simplified: return Int 0 for now
      TomlValue::Int(0)
    } else if s.current() == "t" || s.current() == "f" {
      s = s.advance()
      TomlValue::Bool(true)
    } else {
      s = s.advance()
      TomlValue::Str("")
    }
    
    if key != "" {
      root.set(key, val)
    }
  }
  root
}
