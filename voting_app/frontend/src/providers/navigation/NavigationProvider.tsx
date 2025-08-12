import { useEffect, useState } from "react";
import { NavigationContext } from "./NavigationContext";



type NavigationProviderProps = {
    children: React.ReactNode;

}


const NavigationProvider:React.FC<NavigationProviderProps> = ({children})=> {
    const [currentPage, setCurrentPage] = useState<string>(window.location.pathname);


    const navigate = (page: string) => {
        window.history.pushState({}, "", page);
        setCurrentPage(page)
    };

    useEffect(()=>{
        const handlePopState = () => {
            setCurrentPage(window.location.pathname);
        };

        window.addEventListener("popstate", handlePopState);

        return () => {window.removeEventListener("popstate", handlePopState)}
    })


    return (
        <NavigationContext.Provider value={{currentPage, navigate}}>
            {children}
        </NavigationContext.Provider>
    )
}


export default NavigationProvider;