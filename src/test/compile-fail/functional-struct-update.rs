struct Bar {
    x: int,
    drop { io::println("Goodbye, cruel world"); }
}

struct Foo {
    x: int,
    y: Bar
}

fn main() {
    let a = Foo { x: 1, y: Bar { x: 5 } };
    let c = Foo { x: 4, .. a}; //~ ERROR copying a noncopyable value
    io::println(fmt!("%?", c));
}

