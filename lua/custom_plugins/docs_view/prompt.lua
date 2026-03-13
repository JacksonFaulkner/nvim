
async def generate_report_learning(payload: Report) -> ClientReport:
    """Generate ClientReport with async requests."""

    # Step 1: Get all fields defined on ClientReport
    # fields = {
    #     "overview": FieldInfo(annotation=Overview, ...),
    #     "financials": FieldInfo(annotation=Financials, ...),
    #     "risks": FieldInfo(annotation=Risks, ...),
    # }
    fields = ClientReport.model_fields

    # Step 2: fields.items() gives us (name, FieldInfo) pairs to iterate over
    # [
    #     ("overview", FieldInfo(annotation=Overview)),
    #     ("financials", FieldInfo(annotation=Financials)),
    #     ("risks", FieldInfo(annotation=Risks)),
    # ]

    # Step 3: The generator creates a coroutine for each field
    # (
    #     generate_category(payload, "overview", Overview),
    #     generate_category(payload, "financials", Financials),
    #     generate_category(payload, "risks", Risks),
    # )

    # Step 4: The * unpacks those coroutines as separate args to gather()
    # asyncio.gather(coro1, coro2, coro3)  — runs them all concurrently
    results = await asyncio.gather(
        *(
            generate_category(payload, name, field.annotation)
            for name, field in fields.items()
        )
    )
    # results = [Overview(...), Financials(...), Risks(...)]

    # Step 5: zip pairs up field names with their results
    # zip(["overview", "financials", "risks"], [Overview(...), Financials(...), Risks(...)])
    # -> [("overview", Overview(...)), ("financials", Financials(...)), ("risks", Risks(...))]

    # Step 6: dict() converts those pairs into a dict
    # {"overview": Overview(...), "financials": Financials(...), "risks": Risks(...)}

    # Step 7: ** unpacks that dict as keyword args to ClientReport()
    # ClientReport(overview=Overview(...), financials=Financials(...), risks=Risks(...))
    return ClientReport(**dict(zip(fields.keys(), results)))

