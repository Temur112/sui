import { FC } from "react"




type TextProps = {
    text: string,
    isError?: boolean,
    isCenter?: boolean
}


export const EcText: FC<TextProps> = ({text, isError, isCenter}) => {

    const textColor = isError ? "text-red-500": "text-gray-500";
    const centeredClassname = isCenter ? "text-center": "";


    return (
        <div className={`${centeredClassname} ${textColor}`}>{text}</div>
    )
}