#!/usr/bin/env perl6
use Test;
use JSON::Fast;

my @s =
        'Int'            => [ 1 ],
        'Rat'            => [ 3.2 ],
        'Str'            => [ 'one' ],
        'Str with quote' => [ '"foo"'],
        'Undef'          => [ {}, 1 ],
        'other escapes'  => [ "\\/\"\b\f\n\r\tfoo\\"],
        'Non-ASCII'      => [ 'möp stüff' ],
        'Empty Array'    => [ ],
        'Array of Int'   => [ 1, 2, 3, 123123123 ],
        'Array of Num'   => [ 1.3, 2.8, 32323423.4, 4.0 ],
        'Array of Str'   => [ <one two three gazooba> ],
        'Array of Undef' => [ Any, Any ],
        'Int Allomorph'  => [ IntStr.new(0, '') ] => [ 0 ],
        'Rat Allomorph'  => [ RatStr.new(0.0, '') ] => [0.0],
        'Num Allomorph'  => [ NumStr.new(0e0, '') ] => [0e0],
        'Duration'       => [ Duration.new(57) ] => [ 5.7e1 ],
        'Rational'       => [ Rational[Int,Int].new(3,10) ] => [ 0.3 ],
        'Empty Hash'     => {},
        'Undef Hash Val' => { key => Any },
        'Hash of Int'    => { :one(1), :two(2), :three(3) },
        'Hash of Num'    => { :one-and-some[1], :almost-pie(3.3) },
        'Hash of Str'    => { :one<yes_one>, :two<but_two> },
        'Hash of weird Str' => { "Hello\"" => "good\bye" },
        'Hash: Int keys' => :{ 1 => 1, 2 => 2, 3 => "hi", 4 => "lol" } => ${ "1" => 1, "2" => 2, "3" => "hi", "4" => "lol" },
        'Array of Stuff' => [ { 'A hash' => 1 }, [<an array again>], 2],
        'Hash of Stuff'  =>
                            {
                                keyone   => [<an array>],
                                keytwo   => "A string",
                                keythree => { "another" => "hash" },
                                keyfour  => 4,
                                keyfive  => False,
                                keysix   => True,
                                keyseven => 3.2,
                            },
        'Backslashes 1'  => [ "\"Hi\".literal newlnie:\nbackslashed n:\\nbackslashed newlnie:\\\nbackslashes and quotes: \\\"" ],
        'URLs'           => [ 'http:\/\/www.github.com\/perl6\/nqp\/' ],
        ;

plan @s * 2;

for @s.kv -> $k, $v {
    my $source-data = $v.value ~~ Pair ?? $v.value.key !! $v.value;
    my Str $jsonified = to-json( $source-data, :!pretty );
    is $jsonified.lines.elems, 1, ":!pretty jsonified has only a single line";
    my $r = from-json( $jsonified );
    if $v.value ~~ Pair {
        is-deeply $r, $v.value.value, $v.key;
    } else {
        is-deeply $r, $v.value, $v.key;
    }
}

# vim: ft=perl6
