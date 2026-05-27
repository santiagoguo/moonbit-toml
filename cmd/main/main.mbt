using @lib { parse, serialize, try_parse }

fn main {
  // Test 1: Basic Key-Value pairs
  println("=== Test 1: Basic Key-Value ===")
  let input1 = "title = \"TOML Example\"\nowner = \"Tom\"\nversion = 123"
  let result1 = parse(input1)
  match result1 {
    Some(val) => println("Result: " + val.to_string())
    None => println("Parse failed")
  }
  
  // Test 2: Tables
  println("=== Test 2: Tables ===")
  let input2 = "[server]\nhost = \"192.168.1.1\"\nport = 8080\n[database]\nname = \"myapp\""
  let result2 = parse(input2)
  match result2 {
    Some(val) => println("Result: " + val.to_string())
    None => println("Parse failed")
  }
  
  // Test 3: Arrays
  println("=== Test 3: Arrays ===")
  let input3 = "colors = [\"red\", \"yellow\", \"green\"]"
  let result3 = parse(input3)
  match result3 {
    Some(val) => println("Result: " + val.to_string())
    None => println("Parse failed")
  }
  
  // Test 4: Round-trip
  println("=== Test 4: Round-trip ===")
  let input4 = "name = \"test\"\ncount = 42\nenabled = true"
  let result4 = parse(input4)
  match result4 {
    Some(val) => {
      let serialized = serialize(val)
      println("Serialized: " + serialized)
      let reparsed = parse(serialized)
      match reparsed {
        Some(_) => println("Round-trip OK")
        None => println("Round-trip FAILED")
      }
    }
    None => println("Parse failed")
  }
  
  println("=== All tests completed! ===")
}
