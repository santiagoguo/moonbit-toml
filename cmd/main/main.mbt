using @lib { parse_toml }

fn main {
  // Test 1: Basic Key-Value pairs
  println("=== Test 1: Basic Key-Value ===")
  let input1 = "title = \"TOML Example\"\nowner = \"Tom\"\nversion = 123"
  let result1 = parse_toml(input1)
  println("Result: \{result1.to_string()}")
  
  // Test 2: Tables
  println("\n=== Test 2: Tables ===")
  let input2 = "[server]\nhost = \"192.168.1.1\"\nport = 8080\n[database]\nname = \"myapp\""
  let result2 = parse_toml(input2)
  println("Result: \{result2.to_string()}")
  
  // Test 3: Arrays
  println("\n=== Test 3: Arrays ===")
  let input3 = "colors = [\"red\", \"yellow\", \"green\"]"
  let result3 = parse_toml(input3)
  println("Result: \{result3.to_string()}")
  
  println("\n=== All tests completed! ===")
}
