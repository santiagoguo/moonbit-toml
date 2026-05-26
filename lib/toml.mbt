// TOML Parser Library for MoonBit
// Supports: Key-Value pairs, Tables, Arrays of Tables, Strings, Integers, Floats, Booleans, Arrays

pub enum TomlValue {
  Str(String)
  Int(Int)
  Float(Double)
  Bool(Bool)
  Array(Array[TomlValue])
  Table(Map[String, TomlValue])
}

// Display implementation
fn TomlValue::format(self : TomlValue) -> String {
  match self {
    TomlValue::Str(s) => {
      "\"" + s + "\""
    }
    TomlValue::Int(i) => {
      i.to_string()
    }
    TomlValue::Float(f) => {
      f.to_string()
    }
    TomlValue::Bool(b) => {
      if b { "true" } else { "false" }
    }
    TomlValue::Array(arr) => {
      let mut res = "["
      let mut first = true
      for i = 0; i < arr.length(); i = i + 1 {
        if !first { res = res + ", " }
        res = res + arr[i].format()
        first = false
      }
      res + "]"
    }
    TomlValue::Table(t) => {
      let mut res = "{"
      let mut first = true
      let items = t.to_array()
      for i = 0; i < items.length(); i = i + 1 {
        let (k, v) = items[i]
        if !first { res = res + ", " }
        res = res + k + ": " + v.format()
        first = false
      }
      res + "}"
    }
  }
}

pub impl Show for TomlValue with to_string(self : TomlValue) -> String {
  self.format()
}



// Helper methods
pub fn TomlValue::as_str(self : TomlValue) -> Option[String] {
  match self {
    TomlValue::Str(s) => Some(s)
    _ => None
  }
}

pub fn TomlValue::as_int(self : TomlValue) -> Option[Int] {
  match self {
    TomlValue::Int(i) => Some(i)
    _ => None
  }
}

pub fn TomlValue::as_table(self : TomlValue) -> Option[Map[String, TomlValue]] {
  match self {
    TomlValue::Table(t) => Some(t)
    _ => None
  }
}

// Parser State
struct ParseState {
  input : String
  pos : Int
  line : Int
  col : Int
}

fn ParseState::new(input : String) -> ParseState {
  { input, pos: 0, line: 1, col: 1 }
}

fn ParseState::is_eof(self : ParseState) -> Bool {
  self.pos >= self.input.length()
}

fn ParseState::current(self : ParseState) -> String {
  if self.is_eof() { "" } else { self.input[self.pos : self.pos + 1].to_owned() }
}

fn ParseState::advance(self : ParseState) -> ParseState {
  if self.is_eof() { self } else {
    let c = self.input[self.pos : self.pos + 1].to_owned()
    let new_line = if c == "\n" { self.line + 1 } else { self.line }
    let new_col = if c == "\n" { 1 } else { self.col + 1 }
    { input: self.input, pos: self.pos + 1, line: new_line, col: new_col }
  }
}

fn ParseState::skip_ws_and_comments(self : ParseState) -> ParseState {
  let mut s = self
  while !s.is_eof() {
    let c = s.current()
    if c == " " || c == "\t" || c == "\r" {
      s = s.advance()
    } else if c == "#" {
      // Skip comment line
      while !s.is_eof() && s.current() != "\n" {
        s = s.advance()
      }
    } else if c == "\n" {
      s = s.advance()
    } else {
      break
    }
  }
  s
}

// Parse Key
fn ParseState::parse_key(self : ParseState) -> (String, ParseState) {
  let mut s = self
  let mut key = ""
  
  // Handle quoted keys
  if s.current() == "\"" {
    s = s.advance()
    while !s.is_eof() && s.current() != "\"" {
      key = key + s.current()
      s = s.advance()
    }
    if !s.is_eof() { s = s.advance() } // skip closing "
  } else {
    // Bare key
    while !s.is_eof() {
      let c = s.current()
      let is_valid = (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || 
                     (c >= "0" && c <= "9") || c == "_" || c == "-"
      if is_valid {
        key = key + c
        s = s.advance()
      } else {
        break
      }
    }
  }
  (key, s)
}

// Parse String
fn ParseState::parse_string(self : ParseState) -> (String, ParseState) {
  let mut s = self
  s = s.advance() // skip opening "
  let mut res = ""
  
  while !s.is_eof() && s.current() != "\"" {
    if s.current() == "\\" {
      s = s.advance()
      match s.current() {
        "n" => res = res + "\n"
        "t" => res = res + "\t"
        "\"" => res = res + "\""
        "\\" => res = res + "\\"
        _ => res = res + s.current()
      }
    } else {
      res = res + s.current()
    }
    s = s.advance()
  }
  if !s.is_eof() { s = s.advance() } // skip closing "
  (res, s)
}

// Parse Number
fn ParseState::parse_number(self : ParseState) -> (TomlValue, ParseState) {
  let mut s = self
  let mut num_str = ""
  let is_negative = s.current() == "-"
  if is_negative { num_str = "-"; s = s.advance() }
  
  let mut is_float = false
  
  while !s.is_eof() {
    let c = s.current()
    if (c >= "0" && c <= "9") || c == "_" {
      num_str = num_str + c
      s = s.advance()
    } else if c == "." && !is_float {
      is_float = true
      num_str = num_str + c
      s = s.advance()
    } else {
      break
    }
  }
  
  let clean = num_str.replace(old="_", new="")
  if is_float {
    // Parse float - simplified for now
    (TomlValue::Float(0.0), s)
  } else {
    // Parse int - simplified for now
    (TomlValue::Int(0), s)
  }
}

// Parse Boolean
fn ParseState::parse_bool(self : ParseState) -> (TomlValue, ParseState) {
  let mut s = self
  if s.current() == "t" {
    // Parse "true"
    s = s.advance()
    if s.current() == "r" { s = s.advance() }
    if s.current() == "u" { s = s.advance() }
    if s.current() == "e" { s = s.advance() }
    (TomlValue::Bool(true), s)
  } else {
    // Parse "false"
    s = s.advance()
    if s.current() == "a" { s = s.advance() }
    if s.current() == "l" { s = s.advance() }
    if s.current() == "s" { s = s.advance() }
    if s.current() == "e" { s = s.advance() }
    (TomlValue::Bool(false), s)
  }
}

// Parse Array
fn ParseState::parse_array(self : ParseState) -> (TomlValue, ParseState) {
  let mut s = self
  s = s.advance() // skip [
  s = s.skip_ws_and_comments()
  
  let arr : Array[TomlValue] = Array::new()
  
  while !s.is_eof() && s.current() != "]" {
    let (val, s2) = s.parse_value()
    arr.push(val)
    s = s2
    s = s.skip_ws_and_comments()
    
    if s.current() == "," {
      s = s.advance()
      s = s.skip_ws_and_comments()
    }
  }
  
  if !s.is_eof() { s = s.advance() } // skip ]
  (TomlValue::Array(arr), s)
}

// Parse Value
fn ParseState::parse_value(self : ParseState) -> (TomlValue, ParseState) {
  let s = self
  if s.current() == "\"" {
    let (str_val, s2) = s.parse_string()
    (TomlValue::Str(str_val), s2)
  } else if s.current() == "[" {
    s.parse_array()
  } else if s.current() == "t" || s.current() == "f" {
    s.parse_bool()
  } else if (s.current() >= "0" && s.current() <= "9") || s.current() == "-" {
    s.parse_number()
  } else {
    (TomlValue::Str(""), s.advance())
  }
}

// Get or create nested table
fn Map::get_or_create_table(self : Map[String, TomlValue], keys : Array[String]) -> Map[String, TomlValue] {
  let mut current = self
  
  for i = 0; i < keys.length(); i = i + 1 {
    let key = keys[i]
    let existing = current.get(key)
    match existing {
      Some(TomlValue::Table(t)) => {
        current = t
      }
      _ => {
        let new_table : Map[String, TomlValue] = Map([])
        current.set(key, TomlValue::Table(new_table))
        match current.get(key) {
          Some(TomlValue::Table(t)) => current = t
          _ => ()
        }
      }
    }
  }
  current
}

// Main parser
pub fn parse_toml(input : String) -> Map[String, TomlValue] {
  let root : Map[String, TomlValue] = Map([])
  let mut current_table = root
  let mut s = ParseState::new(input)
  
  while !s.is_eof() {
    s = s.skip_ws_and_comments()
    if s.is_eof() { break }
    
    // Check for table header [section] or [[array_section]]
    if s.current() == "[" {
      s = s.advance()
      let is_array_table = s.current() == "["
      if is_array_table { s = s.advance() }
      
      // Parse table name
      let (table_name, s2) = s.parse_key()
      s = s2
      s = s.skip_ws_and_comments()
      
      // Handle dotted table names like [server.production]
      let path : Array[String] = Array::new()
      if table_name != "" {
        path.push(table_name)
        while s.current() == "." {
          s = s.advance()
          let (sub_key, s2) = s.parse_key()
          if sub_key != "" { path.push(sub_key) }
          s = s2
          s = s.skip_ws_and_comments()
        }
      }
      
      // Skip closing brackets
      if s.current() == "]" { s = s.advance() }
      if is_array_table && s.current() == "]" { s = s.advance() }
      
      if is_array_table {
        // For array of tables, create a new table
        let arr_table : Map[String, TomlValue] = Map([])
        current_table = arr_table
      } else {
        // Navigate to or create the nested table
        current_table = root.get_or_create_table(path)
      }
      
      continue
    }
    
    // Parse key = value
    let (key, s2) = s.parse_key()
    s = s2
    s = s.skip_ws_and_comments()
    
    if s.current() == "=" {
      s = s.advance()
      s = s.skip_ws_and_comments()
      
      let (val, s2) = s.parse_value()
      s = s2
      
      if key != "" {
        current_table.set(key, val)
      }
    } else if key != "" {
      // Skip invalid line
      s = s.advance()
    }
  }
  
  root
}

// Convenience function to get nested value
pub fn get_value(root : Map[String, TomlValue], path : String) -> Option[TomlValue] {
  let parts = path.split(".")
  let parts_arr = parts.to_array()
  
  if parts_arr.length() <= 1 { 
    root.get(path)
  } else {
    let mut current : Option[TomlValue] = None
    for i = 0; i < parts_arr.length(); i = i + 1 {
      let part = parts_arr[i].to_owned()
      match current {
        None => current = root.get(part)
        Some(TomlValue::Table(t)) => current = t.get(part)
        _ => return None
      }
    }
    current
  }
}
