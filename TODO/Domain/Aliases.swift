// 特別なデータ構造を定義するまでもないエイリアスや、具体的なデータ構造を決めかねているものをここに定義する

public typealias Color = (r: Int, g: Int, b: Int, a: Int)
func ==(lhs: Color, rhs: Color) -> Bool {
    return lhs.r == rhs.r
        && lhs.g == rhs.g
        && lhs.b == rhs.b
        && lhs.a == rhs.a
}

public typealias Date = Int64
