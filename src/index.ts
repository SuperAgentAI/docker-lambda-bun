export const handler = async () => {
  return new Response(
    JSON.stringify({ status: 501, message: 'empty function' }),
    {
      status: 501,
      headers: {
        'Content-Type': 'application/json',
      },
    },
  )
}
