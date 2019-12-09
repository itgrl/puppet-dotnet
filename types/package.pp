type DotNet::Package = Struct[
  {
    'key' => Pattern[
      /\A[0-9A-F]{8}(-[0-9A-F]{4}){3}-[0-9A-F]{12}\z/
    ],
    'url' => Stdlib::HTTPUrl,
  }
]
